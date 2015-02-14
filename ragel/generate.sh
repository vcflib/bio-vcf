#! /bin/bash

ragel -R gen_vcfheaderline_parser.rl 
[ $? -ne 0 ] && exit 1

ruby gen_vcfheaderline_parser.rb

cp gen_vcfheaderline_parser.rb ../lib/bio-vcf/vcfheader_line.rb
