# bio-vcf

[![Build Status](https://secure.travis-ci.org/pjotrp/bioruby-vcf.png)](http://travis-ci.org/pjotrp/bioruby-vcf) 

Yet another VCF parser. This one may give better performance and
useful command line filtering.

The VCF format is commonly used for variant calling between NGS
samples. The fast parser needs to carry some state, recorded for each
file in VcfHeader, which contains the VCF file header. Individual
lines (variant calls) first go through a raw parser returning an array
of fields. Further (lazy) parsing is handled through VcfRecord.

Health warning: Early days, your mileage may vary because I add
features as I go along! If something is not working, check out the
code. It is easy to add features.

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
  bio-vcf -q -eval-once 'header.column_names.join(",")' < file.vcf
  CHROM,POS,ID,REF,ALT,QUAL,FILTER,INFO,FORMAT,NORMAL,TUMOR
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

With subfields defined by rec.format

```ruby
  bio-vcf --filter 'rec.tumor.ss != 2' < file.vcf 
```

Output

```ruby
  bio-vcf --filter 'rec.tumor.gq>30' --eval '[rec.ref,rec.alt,rec.tumor.bcount,rec.tumor.gq,rec.normal.gq].join("\t")' < file.vcf
```

Show the count of the bases that were scored as somatic

```ruby
  bio-vcf --eval 'rec.alt+"\t"+rec.tumor.bcount.split(",")[["A","C","G","T"].index(rec.alt)]+"\t"+rec.tumor.gq.to_s' < file.vcf
```

Actually, we have a convenience implementation for bcount, so this is the same

```ruby
  bio-vcf --eval 'rec.alt+"\t"+rec.tumor.bcount[rec.alt].to_s+"\t"+rec.tumor.gq.to_s' < file.vcf
```

Filter on the somatic results that were scored at least 4 times
 
```ruby
  bio-vcf --filter 'rec.alt.size==1 and rec.tumor.bcount[rec.alt]>4' < test.vcf 
```

Similar for base quality scores

```ruby
  bio-vcf --filter 'rec.alt.size==1 and rec.tumor.amq[rec.alt]>30' < test.vcf 
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

