# bio-vcf

[![Build Status](https://secure.travis-ci.org/pjotrp/bioruby-vcf.png)](http://travis-ci.org/pjotrp/bioruby-vcf) 

Yet another VCF parser. This one may give better performance because
of lazy parsing and useful combinations of (fancy) command line
filtering. For example, to filter somatic data 

```ruby
  bio-vcf --filter 'rec.alt.size==1 and rec.tumor.bq[rec.alt]>30 and rec.tumor.mq>20' < file.vcf
```

The VCF format is commonly used for variant calling between NGS
samples. The fast parser needs to carry some state, recorded for each
file in VcfHeader, which contains the VCF file header. Individual
lines (variant calls) first go through a raw parser returning an array
of fields. Further (lazy) parsing is handled through VcfRecord. 

At this point the filter is pretty generic with multi-sample support.
If something is not working, check out the feature descriptions and
the source code. It is not hard to add features. Otherwise, send me a short
example of a VCF statement you need to work on.

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

To filter missing on samples:

  bio-vcf --filter "rec.s3t2?" < file.vcf

or for all

  bio-vcf --filter "rec.missing_samples?" < file.vcf

Likewise you can check for record validity

  bio-vcf --filter "not rec.valid?" < file.vcf

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

