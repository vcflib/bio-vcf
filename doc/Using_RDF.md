# Using bio-vcf with RDF

bio-vcf can output many types of formats. In this exercise we will load
a triple store (4store) with VCF data and do some queries on that.

## Install and start 4store

As root

```sh
apt-get install avahi-daemon
guix package -i sparql-query curl
apt-get install raptor-utils
```

Initialize and start the server

```
export PATH=/home/user/.guix-profile/bin:$PATH
dbname=test
4s-backend-setup $dbname
4s-backend $dbname
4s-httpd -p 8000 $dbname
```

Generate rdf with bio-vcf template

```ruby
=HEADER
@prefix : <http://biobeat.org/rdf/ns#> .
=BODY
<%
id = ['chr'+rec.chr,rec.pos,rec.alt].join('_')
%> 
:<%= id %>
  :query_id "<%= id %>";
  :chr "<%= rec.chr %>" ;
  :alt "<%= rec.alt.join("") %>" ;
  :pos <%= rec.pos %> . 
  

```

so it looks like

```
:chrX_134713855_A
  :query_id "chrX_134713855_A";
  :chr "X" ;
  :alt "A" ;
  :pos 134713855 .
```

and test with rapper

```sh
cat gatk_exome.vcf |bio-vcf -v --template rdf_template.erb
cat gatk_exome.vcf |bio-vcf -v --template rdf_template.erb > my.rdf
rapper -i turtle my.rdf
```

Load into 4store (when no errors)

```bash
rdf=my.rdf
uri=http://localhost:8000/data/http://biobeat.org/data/$rdf
curl -X DELETE $uri
curl -T $rdf -H 'Content-Type: application/x-turtle' $uri
201 imported successfully
This is a 4store SPARQL server 
```

First SPARQL query

```sh
SELECT ?id
WHERE
{
  ?id   <http://biobeat.org/rdf/ns#chr>    "X".
}
```

```
cat sparql1.rq |sparql-query "http://localhost:8000/sparql/" -p 
┌──────────────────────────────────────────────┐
│ ?id                                          │
├──────────────────────────────────────────────┤
│ <http://biobeat.org/rdf/ns#chrX_107911706_C> │
│ <http://biobeat.org/rdf/ns#chrX_55172537_A>  │
│ <http://biobeat.org/rdf/ns#chrX_134713855_A> │
└──────────────────────────────────────────────┘
```

