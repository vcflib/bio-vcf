# Using bio-vcf with RDF

bio-vcf can output many types of formats. In this exercise we will load
a triple store (4store) with VCF data and do some queries on that.

## Install and start 4store

### On GNU Guix

See https://github.com/pjotrp/guix-notes/blob/master/packages/4store.org

### On Debian

Get root

```sh
su
apt-get install avahi-daemon
apt-get install raptor-utils
exit
```

As normal user

```sh
guix package -i sparql-query curl
```

Initialize and start the server again as root (or another user)

```
su
export PATH=/home/user/.guix-profile/bin:$PATH
mkdir -p /var/lib/4store
dbname=test
4s-backend-setup $dbname
4s-backend $dbname
4s-httpd -p 8000 $dbname
```

Try the web browser and point it to http://localhost:8000/status/

Open a new terminal as user.


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

and test with rapper using [gatk_exome.vcf](https://github.com/pjotrp/bioruby-vcf/blob/master/test/data/input/gatk_exome.vcf)

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

A simple python query may look like

```python
import requests
import subprocess

host = "http://localhost:8000/"

query = """
SELECT ?s ?p ?o WHERE {
    ?s ?p ?o .
} LIMIT 10
"""

r = requests.post(host, data={ "query": query, "output": "text" })
# print r.url

print r.text
```

renders

```
?id
<http://biobeat.org/rdf/ns#chrX_107911706_C>
<http://biobeat.org/rdf/ns#chrX_55172537_A>
<http://biobeat.org/rdf/ns#chrX_134713855_A>
```

## EBI


EBI SPARQL has some advanced examples of queries, such as

```
https://www.ebi.ac.uk/rdf/services/ensembl/sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX sio: <http://semanticscience.org/resource/>
PREFIX faldo: <http://biohackathon.org/resource/faldo#>
PREFIX identifiers: <http://identifiers.org/>
PREFIX ensembl: <http://rdf.ebi.ac.uk/resource/ensembl/>
PREFIX ensembltranscript: <http://rdf.ebi.ac.uk/resource/ensembl.transcript/>
PREFIX ensemblexon: <http://rdf.ebi.ac.uk/resource/ensembl.exon/>
PREFIX ensemblprotein: <http://rdf.ebi.ac.uk/resource/ensembl.protein/>
PREFIX ensemblterms: <http://rdf.ebi.ac.uk/terms/ensembl/>

SELECT DISTINCT ?transcript ?id ?typeLabel ?reference ?begin ?end ?location {
  ?transcript obo:SO_transcribed_from ensembl:ENSG00000139618 ;
              a ?type;
              dc:identifier ?id .
  OPTIONAL {
    ?transcript faldo:location ?location .
    ?location faldo:begin [faldo:position ?begin] .
    ?location faldo:end [faldo:position ?end ] .
    ?location faldo:reference ?reference .
  }
  OPTIONAL {?type rdfs:label ?typeLabel}
}
```

See https://www.ebi.ac.uk/rdf/services/ensembl/sparql

# Exercise

Today's exercise is to create a graph using bio-vcf and/or a small program using
RDF triples and define a SPARQL query.

The more interesting the graph/SPARQL the better.
