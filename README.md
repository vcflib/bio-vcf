# bio-vcf

[![Build Status](https://secure.travis-ci.org/pjotrp/bioruby-vcf.png)](http://travis-ci.org/pjotrp/bioruby-vcf) 

Yet another VCF parser. This one may give better performance because
of lazy parsing and useful combinations of (fancy) command line
filtering. Also few assumptions are made about the actual contents of
the VCF file (field names are resolved on the fly).

For example, to filter somatic data 

```ruby
  bio-vcf --filter 'rec.alt.size==1 and rec.tumor.bq[rec.alt]>30 and rec.tumor.mq>20' < file.vcf
```

To output specific fields in tabular (and HTML, XML or LaTeX) format
use the --eval switch, e.g.,

```ruby
  bio-vcf --eval 'rec.alt+"\t"+rec.tumor.bcount.split(",")[["A","C","G","T"].index(rec.alt)]+"\t"+rec.tumor.gq.to_s' < file.vcf
```

Filter and eval commands can be used at the same time.  Also note you
can use [bio-table](https://github.com/pjotrp/bioruby-table) to
filter/transform data further and convert to other formats, such as
RDF.

The VCF format is commonly used for variant calling between NGS
samples. The fast parser needs to carry some state, recorded for each
file in VcfHeader, which contains the VCF file header. Individual
lines (variant calls) first go through a raw parser returning an array
of fields. Further (lazy) parsing is handled through VcfRecord. 

At this point the filter is pretty generic with multi-sample support.
If something is not working, check out the feature descriptions and
the source code. It is not hard to add features. Otherwise, send a short
example of a VCF statement you need to work on.

bio-vcf is fast. Parsing a 55K line DbSNP file (22Mb) takes 5 seconds on a
Macbook PRO running 64-bits Linux (Ruby 2.1.0).

## Installation

```sh
gem install bio-vcf
```

## Quick start

## Command line interface (CLI)

Get the version of the VCF file

```ruby
  bio-vcf -q --eval-once header.version < file.vcf
  4.1
```

Get the column headers

```ruby
  bio-vcf -q --eval-once 'header.column_names.join(",")' < file.vcf
  CHROM,POS,ID,REF,ALT,QUAL,FILTER,INFO,FORMAT,NORMAL,TUMOR
```

Get the sample names

```ruby
  bio-vcf -q --eval-once 'header.samples.join(",")' < file.vcf
  NORMAL,TUMOR
```

The 'fields' array contains unprocessed data (strings).  Print first
five raw fields

```ruby
  bio-vcf --eval 'fields[0..4].join("\t")' < file.vcf 
```

Add a filter to display the fields on chromosome 12

```ruby
  bio-vcf --filter 'fields[0]=="12"' --eval 'fields[0..4].join("\t")' < file.vcf 
```

It gets better when we start using processed data, represented by an
object named 'rec'. Position is a value, so we can filter a range

```ruby
  bio-vcf --filter 'rec.chrom=="12" and rec.pos>96_641_270 and rec.pos<96_641_276' < file.vcf 
```

Info fields are referenced by

```ruby
  bio-vcf --filter 'rec.info.dp>100 and rec.info.readposranksum<=0.815' < file.vcf 
```

With subfields defined by rec.format

```ruby
  bio-vcf --filter 'rec.tumor.ss != 2' < file.vcf 
```

Output

```ruby
  bio-vcf --filter 'rec.tumor.gq>30' 
    --eval '[rec.ref,rec.alt,rec.tumor.bcount,rec.tumor.gq,rec.normal.gq].join("\t")' 
    < file.vcf
```

Show the count of the bases that were scored as somatic

```ruby
  bio-vcf --eval 'rec.alt+"\t"+rec.tumor.bcount.split(",")[["A","C","G","T"].index(rec.alt)]+
    "\t"+rec.tumor.gq.to_s' < file.vcf
```

Actually, we have a convenience implementation for bcount, so this is the same

```ruby
  bio-vcf --eval 'rec.alt+"\t"+rec.tumor.bcount[rec.alt].to_s+"\t"+rec.tumor.gq.to_s' 
    < file.vcf
```

Filter on the somatic results that were scored at least 4 times
 
```ruby
  bio-vcf --filter 'rec.alt.size==1 and rec.tumor.bcount[rec.alt]>4' < test.vcf 
```

Similar for base quality scores

```ruby
  bio-vcf --filter 'rec.alt.size==1 and rec.tumor.amq[rec.alt]>30' < test.vcf 
```

Filter out on sample values

```ruby
  bio-vcf --sfilter 'dp>20' < test.vcf 
```

To filter missing on samples:

```sh
  bio-vcf --filter "rec.s3t2?" < file.vcf
```

or for all

```sh
  bio-vcf --filter "rec.missing_samples?" < file.vcf
```

Likewise you can check for record validity

```sh
  bio-vcf --filter "not rec.valid?" < file.vcf
```

which, at this point, simply counts the number of fields.

If your samples have other names you can fetch genotypes for that
sample with

```sh
  bio-vcf --eval "rec.sample['Original'].gt" < file.vcf
```

Or read depth for another

```sh
  bio-vcf --eval "rec.sample['s3t2'].dp" < file.vcf
```

Better even, you can access samples directly with

```sh
  bio-vcf --eval "rec.sample.original.gt" < file.vcf
  bio-vcf --eval "rec.sample.s3t2.dp" < file.vcf
```

And even better because of Ruby magic

```sh
  bio-vcf --eval "rec.original.gt" < file.vcf
  bio-vcf --eval "rec.s3t2.dp" < file.vcf
```

Note that only valid method names in lower case get picked up this
way. Also by convention normal is sample 1 and tumor is sample 2.

Even shorter r is an alias for rec (nyi) 

```sh
  bio-vcf --eval "r.original.gt" < file.vcf
  bio-vcf --eval "r.s3t2.dp" < file.vcf
```

## Special functions

Sometime you want to use a special function in a filter. For 
example percentage variant reads can be defined as [a,c,g,t] 
with frequencies against sample read depth (dp) as 
[0,0.03,0.47,0.50]. Filtering would with a special function, 
which we named freq

```sh
  bio-vcf --sfilter "freq[2]>0.30" < file.vcf
```

which is equal to 

```sh
  bio-vcf --sfilter "freq.g>0.30" < file.vcf
```

To check for ref or variant frequencies use more sugar

```sh
  bio-vcf --sfilter "freq.var>0.30 and freq.ref<0.10" < file.vcf
```

## DbSNP

One clinical variant DbSNP example 

```sh
    bio-vcf --eval '[rec.id,rec.chr,rec.pos,rec.alt,rec.info.sao,rec.info.CLNDBN].join("\t")' < clinvar_20140303.vcf
```

renders

```
  1       1916905 rs267598254     A       3       Malignant_melanoma
  1       1916906 rs267598255     A       3       Malignant_melanoma
  1       1959075 rs121434580     C       1       Generalized_epilepsy_with_febrile_seizures_plus_type_5
  1       1959699 rs41307846      A       1       Generalized_epilepsy_with_febrile_seizures_plus_type_5|Epilepsy\x2c_juvenile_myoclonic_7|Epilepsy\x2c_idiopathic_generalized_10
  1       1961453 rs142619552     T       3       Malignant_melanoma
  1       2160299 rs387907304     G       0       Shprintzen-Goldberg_syndrome
  1       2160305 rs387907306     A       T       0       Shprintzen-Goldberg_syndrome,Shprintzen-Goldberg_syndrome
  1       2160306 rs387907305     A       T       0       Shprintzen-Goldberg_syndrome,Shprintzen-Goldberg_syndrome
  1       2160308 rs397514590     T       0       Shprintzen-Goldberg_syndrome
  1       2160309 rs397514589     A       0       Shprintzen-Goldberg_syndrome
```

## Set analysis

### Complement

Filter specified samples that evaluate to true, all others should evaluate to
false

i=inc.
e=excl.
s=any. 

```sh
--set-union      default
--set-complement include=true, exclude=false
  bio-vcf --include /s3.+/ --sfilter 'dp>20'  --ifilter 'gt==s3t1.gt' --efilter 'gt!=s3t1.gt' 
  bio-vcf --include /s3.+/ --sfilter 'dp>20'  --ifilter 'gt==s3t1.gt' --efilter 'gt!=s3t1.gt' 
--set-intersect  include=true
  bio-vcf --include /s3.+/ --sample /t2/ --sfilter 'dp>20'  --ifilter 'gt==s3t1.gt'  
--set-catesian   one in include=true, rest=false
  bio-vcf --unique-sample (any) --include /s3.+/ --sfilter 'dp>20' --ifilter 'gt!="0/0"'  
```

  bio-vcf --sfilter "freq.var>0.30 and freq.ref<0.10" < file.vcf

For all includes var should be identical for set analysis except for
catesian. So when --include is defined test for identical var and in
the case of cartesian one unique var, when tested.

ref should always be identical across samples.

Unlike the --filter, the set filters --ifilter, --efilter and
--sfilter ignore missing data. To test for missing data
in set filters use --strict.

With the --filter command you can use --ignore-missing-data to skip
errors.

## RDF output

Use [bio-table](https://github.com/pjotrp/bioruby-table) to convert tabular data to RDF.

## Other examples

For more examples see the feature [section](https://github.com/pjotrp/bioruby-vcf/tree/master/features).

## API

BioVcf can also be used as an API. The following code is basically
what the command line interface uses (see ./bin/bio-vcf)

```ruby
  FILE.each_line do | line |
    if line =~ /^##fileformat=/
      # ---- We have a new file header
      header = VcfHeader.new
      header.add(line)
      STDIN.each_line do | headerline |
        if headerline !~ /^#/
          line = headerline
          break # end of header
        end
        header.add(headerline)
      end
    end
    # ---- Parse VCF record line
    # fields = VcfLine.parse(line,header.columns)
    fields = VcfLine.parse(line)
    rec = VcfRecord.new(fields,header)
    #
    # Do something with rec
    #
  end
```

## Project home page

Information on the source tree, documentation, examples, issues and
how to contribute, see

  http://github.com/pjotrp/bioruby-vcf

## Cite

If you use this software, please cite one of
  
* [BioRuby: bioinformatics software for the Ruby programming language](http://dx.doi.org/10.1093/bioinformatics/btq475)
* [Biogem: an effective tool-based approach for scaling up open source software development in bioinformatics](http://dx.doi.org/10.1093/bioinformatics/bts080)

## Biogems.info

This Biogem is published at (http://biogems.info/index.html#bio-vcf)

## Copyright

Copyright (c) 2014 Pjotr Prins. See LICENSE.txt for further details.

