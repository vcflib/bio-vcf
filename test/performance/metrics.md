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

Late parsing of info field without split:

    real    0m1.124s
    user    0m1.120s
    sys     0m0.008s

Global sample info caching

    real    0m1.032s
    user    0m1.020s
    sys     0m0.008s

Assign some repeated Hash queries

    real    0m1.028s
    user    0m1.024s
    sys     0m0.000s

Profiler now picking out eval for further optimization

      %   cumulative   self              self     total
     time   seconds   seconds    calls  ms/call  ms/call  name
     10.45     1.80      1.80    34968     0.05     0.59  Object#parse_line
      7.89     3.16      1.36    34968     0.04     0.17  Kernel.eval
      5.69     4.14      0.98    34253     0.03     0.57  BioVcf::VcfRecord#each_sample
      4.93     4.99      0.85    12497     0.07     1.37  nil#

Compiling sample eval

    real    0m0.820s
    user    0m0.812s
    sys     0m0.004s

Compiling record eval

    real    0m0.647s
    user    0m0.644s
    sys     0m0.000s

Walk examples by index, rather than by name

    real    0m0.612s
    user    0m0.596s
    sys     0m0.012s

More caching

    real    0m0.600s
    user    0m0.592s
    sys     0m0.004s

And the latest profiling

      %   cumulative   self              self     total
     time   seconds   seconds    calls  ms/call  ms/call  name
     12.98     2.02      2.02    34968     0.06     0.51  Object#parse_line
      7.78     3.23      1.21    22518     0.05     0.14  BioVcf::VcfRecord#sample_by_index
      5.59     4.10      0.87    34253     0.03     0.47  BioVcf::VcfRecord#each_sample
      4.82     4.85      0.75    34968     0.02     0.03  BioVcf::ConvertStringToValue.integer?
      4.50     5.55      0.70    12450     0.06     0.13  BioVcf::VcfRecordInfo#method_missing
      4.31     6.22      0.67    69974     0.01     0.03  Class#new
      4.24     6.88      0.66    12499     0.05     1.23  nil#
      3.79     7.47      0.59    12450     0.05     0.06  BioVcf::VcfLine.parse

Introduced --use-threads

    time ./bin/bio-vcf -i --use-threads --filter 'r.info.dp>20' --sfilter 's.dp>10' < test/tmp/test.vcf > /dev/null

on a dual-core running Linux

    real    0m0.389s
    user    0m1.132s
    sys     0m0.148s

