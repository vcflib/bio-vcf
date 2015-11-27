#! /bin/bash
#
# Stress test bio-vcf by running it on large files and comparing
# results using threads

input=test/data/input/multisample.vcf
filter='--sfilter 's.dp>70' --seval s.dp'

echo "cat $input | ./bin/bio-vcf --num-threads 1 $filter > stress_simple01.vcf"
cat $input | ./bin/bio-vcf --num-threads 1 $filter > stress_simple01.vcf
cat $input | ./bin/bio-vcf --num-threads 2 $filter > stress_simple02.vcf
cat $input | ./bin/bio-vcf --num-threads 4 $filter > stress_simple03.vcf
cat $input | ./bin/bio-vcf $filter > stress_simple04.vcf
cat $input | ./bin/bio-vcf --thread-lines 3 $filter > stress_simple05.vcf
cat $input | ./bin/bio-vcf --thread-lines 1 $filter > stress_simple06.vcf
