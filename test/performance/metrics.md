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

Cache sample index 

    real    0m1.156s
    user    0m1.148s
    sys     0m0.004s

Run the profiler 

  ruby  -rprofile  ./bin/bio-vcf -i --filter 'r.info.dp>20' --sfilter 's.dp>10' < test/tmp/test.vcf > /dev/null
  vcf 0.0.3-pre4 (biogem Ruby 2.1.0) by Pjotr Prins 2014
  Options: {:show_help=>false, :ignore_missing=>true, :filter=>"r.info.dp>20", :sfilter=>"s.dp>10"}
    %   cumulative   self              self     total
   time   seconds   seconds    calls  ms/call  ms/call  name
    9.45     2.19      2.19    34968     0.06     0.76  Object#parse_line
    7.25     3.87      1.68    75031     0.02     0.03  BioVcf::VcfRecordInfo#[]=
    7.12     5.52      1.65    34968     0.05     0.29  Kernel.eval
    6.86     7.11      1.59    87481     0.02     0.10  BioVcf::VcfRecordInfo#initialize
    5.57     8.40      1.29    35994     0.04     0.47  Array#each
    4.14     9.36      0.96    34253     0.03     0.65  BioVcf::VcfRecord#each_sample
    3.93    10.27      0.91    93880     0.01     0.03  BioVcf::VcfRecordParser.get_format
    3.88    11.17      0.90   145920     0.01     0.01  String#split


