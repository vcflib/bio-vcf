Round of testing with

    ruby -v
    ruby 2.1.0p0 (2013-12-25 revision 44422) [x86_64-linux]

    wc test/tmp/test.vcf 
      12469  137065 2053314 test/tmp/test.vcf

    time ./bin/bio-vcf -i --filter 'r.info.dp>20' --sfilter 's.dp>10' < test/tmp/test.vcf > /dev/null
    vcf 0.0.3-pre4 (biogem Ruby 2.1.0) by Pjotr Prins 2014
    Options: {:show_help=>false, :ignore_missing=>true, :filter=>"r.info.dp>20", :sfilter=>"s.dp>10"}
    real    0m1.215s
    user    0m1.208s
    sys     0m0.004s

Reload

    time ./bin/bio-vcf -i --filter 'r.info.dp>20' --sfilter 's.dp>10' < test/tmp/test.vcf > /dev/null
    vcf 0.0.3-pre4 (biogem Ruby 2.1.0) by Pjotr Prins 2014
    Options: {:show_help=>false, :ignore_missing=>true, :filter=>"r.info.dp>20", :sfilter=>"s.dp>10"}
    real    0m1.194s
    user    0m1.172s
    sys     0m0.016s

Introduced method caching
        
    real    0m1.190s
    user    0m1.180s
    sys     0m0.004s

Introduce !!Float test

    real    0m1.187s
    user    0m1.180s
    sys     0m0.004s


