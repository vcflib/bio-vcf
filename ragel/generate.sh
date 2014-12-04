#! /bin/bash

ragel -R gen_vcfheaderline_parser.rl ; ruby gen_vcfheaderline_parser.rb

