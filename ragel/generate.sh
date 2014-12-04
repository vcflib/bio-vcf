#! /bin/bash

ragel -R gen_vcfheaderline_parser.rl ; ruby gen_vcfheaderline_parser.rb

cp gen_vcfheaderline_parser.rb ../lib/bio-vcf/vcfheader_line.rb
