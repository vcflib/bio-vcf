# Comparing two large GATK files

This is the exercise to explore the differences in the full BWA-GATK
pipeline vs. a chunking-scatter-gather approach that is magnitudes
faster. Using my tools
[bio-vcf](https://github.com/pjotrp/bioruby-vcf),
[bio-table](https://github.com/pjotrp/bioruby-table) and
[bio-locus](https://github.com/pjotrp/bio-locus) interesting
edge effects were found.

The GATK output variant files are similar in size:

    -rw-r--r-- 1 pjotr users 992725762 Aug 29 11:22 HiSeqX_R1.fastq.sorted_dedup_realigned.bam.realigned.raw_variants.vcf
    -rw-r--r-- 1 pjotr users 987147441 Aug 29 11:26 HiSeqX_R1.fastq_dedup_realigned.bam.realigned.raw_variants.vcf

Naming suggests the second one (scatter) is unsorted but it is actually sorted.

Install bio-vcf, add it to the path if required, and you should see

    gem env
    export PATH=$GEM_HOME/bin:PATH
    gem install bio-vcf
    bio-vcf
    bio-vcf 0.9.0 (biogem Ruby 2.1.2 with pcows) by Pjotr Prins 2015

Create simple position files with calls

    /usr/bin/time -v bio-vcf -e '[r.chrom,r.pos,r.alt]' < scatter/HiSeqX_R1.fastq_dedup_realigned.bam.realigned.raw_variants.vcf > scatter_calls.vcf
    /usr/bin/time -v bio-vcf -e '[r.chrom,r.pos,r.alt]' < full/HiSeqX_R1.fastq.sorted_dedup_realigned.bam.realigned.raw_variants.vcf > full_calls.vcf

Count the calls (we are ignoring the limited header info)

    wc -l scatter_calls.vcf 
      4773423 scatter_calls.vcf

    wc -l full_calls.vcf 
      4795998 full_calls.vcf

(4795998-4773423)/4795998*100 or 0.5%. Do a diff and count de diffs

    egrep -c '^>' calls.diff 
      30401
    egrep -c '^<' calls.diff 
      52976

52976/4795998*100 or 1.1% of different calls, hmmm. Remove the GL contig

    grep -v GL00 calls.diff > calls_wo_GL00.diff
    egrep -c '^<' calls_wo_GL00.diff 
      48797

Now install bio-table and bio-locus

     gem install bio-table
     bio-table
       bio-table 1.0.0 Copyright (C) 2012-2014 Pjotr Prins <pjotr.prins@thebird.nl>
     gem install bio-locus
     bio-locus
       bio-locus 0.0.6 (biogem Ruby 2.1.2) by Pjotr Prins 2014

Create a new VCF file using the diff information. Find all the calls

     egrep '^(<|>)' calls_wo_GL00.diff |grep -v GATKCommandLine| grep -v CHROM > all_diff.txt
     bio-table --columns 0,1 < all_diff.txt > chrom_pos_diff.txt

with vi remove first > and < and make sure there is a tab: 

     %s/^..//g
     %s/$/^INA/g

Now use bio-locus to create full VCF files containing only these entries

     bio-locus --store --alt exclude < chrom_pos_diff.txt 
     bio-locus 0.0.6 (biogem Ruby 2.1.2) by Pjotr Prins 2014
       Stored 73644 positions out of 75414 in locus.db (1770 duplicate hits)
     bio-locus --match --alt exclude < ../full/HiSeqX_R1.fastq.sorted_dedup_realigned.bam.realigned.raw_variants.vcf > diff_full.vcf
     bio-locus --match --verbose -d < ../scatter/HiSeqX_R1.fastq_dedup_realigned.bam.realigned.raw_variants.vcf > diff_scatter.vcf
     (note: bio-locus is - still - a slow tool)

Interestingly there is very little overlap between the call positions (only 1770 are shared)...

     wc -l diff*.vcf
       48903 diff_full.vcf
       26731 diff_scatter.vcf

So, arguably the difference is
(48903+26731)/4795998*100 or 1.6% of calls.

Now we can compare the call contents

     bio-vcf -i -e '[r.chrom,r.pos,r.info.af]' --seval 's.dp' < diff_scatter.vcf > diff_scatter_af_sdp.txt

For those that do match we see a difference in sample read depth
pointing out the two methods differ in placing reads. So, let's see
if we can find significant differences in frequency and read depth.

First I am reducing the data to one chromosome to be able to work a bit
faster

     bio-vcf --filter 'r.chrom=="3"' < ../full/HiSeqX_R1.fastq.sorted_dedup_realigned.bam.realigned.raw_variants.vcf > full.vcf
     bio-vcf --filter 'r.chrom=="3"' < ../scatter/HiSeqX_R1.fastq_dedup_realigned.bam.realigned.raw_variants.vcf > scatter.vcf
     wc -l *.vcf
       301922 full.vcf
       300326 scatter.vcf

     bio-vcf -i -e '[r.pos,r.alt,r.info.af]' --seval 's.dp' < full.vcf > full_af_dp.txt
     bio-vcf -i -e '[r.pos,r.alt, r.info.af]' --seval 's.dp' < scatter.vcf > scatter_af_dp.txt
     wc -l *.txt
       40001 full_af_dp.txt
       40001 scatter_af_dp.txt
     diff scatter_af_dp.txt full_af_dp.txt |grep -c '>'
       2189

Differences typically look like 

      < 402884        G       0.5     26
      < 403020        A       0.5     21
      ---
      > 402884        G       0.5     29
      > 403020        A       0.5     25

i.e. the scatter approach has a different read depth 26 instead of 29
and 21 instead of 25 - reads end up in other places. Frequency-wise we
don't see much differentce. More intriguing, a difference would be

    1525d1529
    < 663038        CATATGTTATATGTGTATGTATTGTATACAT 1.0     4

where an extra call for an insertion was made in the scatter approach
with a DP of 4.

Now let's quantify how much DP differs 

Combine the tables

      bio-table --columns 0,3 < full_af_dp.txt > f_dp.txt 
      bio-table --columns 0,3 < scatter_af_dp.txt > s_dp.txt
      bio-table --merge f_dp.txt s_dp.txt > merged.txt

After editing the table header to show 'pos\tfull\tscatter' 

      bio-table --num-filter 'value[1]!=value[0]' < merged.txt |wc -l
        2416

it shows that for chromosome 3, 2416 calls out of 301922 (0.8%) have a
different read depth. 

      bio-table --verbose --debug --num-filter '(value[1]-value[0]).abs > 3' < merged_no_NA.txt|wc -l
        356

356 (0.1% of total calls) showed a read depth difference larger than 4
reads. And 61 showed a read depth difference larger than 10 reads:

      fedor13:~/bcosc/gvcf/chr3$ bio-table --verbose --debug --num-filter '(value[1]-value[0]).abs > 10' < merged_no_NA.txt 
      bio-table 1.0.0 Copyright (C) 2012-2014 Pjotr Prins <pjotr.prins@thebird.nl>
       INFO bio-table: Array: [{:show_help=>false, :write_header=>true, :skip=>0, :debug=>true, :num_filter=>"(value[1]-value[0]).abs > 10"}]
      DEBUG bio-table: Filtering on (value[1]-value[0]).abs > 10
       INFO bio-table: Array: ["pos", "full", "scatter"]
      pos             full    scatter
      855606          24      9
      855609          24      10
      855610          24      10
      855617          22      9
      1432738         17      3
      1434184         35      22
      3173353         37      7
      3713421         42      11
      3713601         31      13
      3713646         39      24
      3713647         39      24
      3713669         43      29
      3714214         33      19
      3762444         18      3
      3764753         29      15
      3764808         29      15
      3764830         26      15
      3764904         22      11
      3764918         24      13
      3937379         26      13
      3937468         19      7
      4005161         17      4
      4005568         35      22
      4297382         27      13
      4297644         34      20
      4958959         31      10
      4958960         31      10
      4959272         35      11
      4959609         27      9
      4960175         27      5
      6159995         17      0.5
      8432601         34      23
      8432973         24      13
      8432986         26      15
      11414301        12      28
      11414307        12      28
      11414313        12      28
      11414323        12      28
      11528593        21      6
      12070044        39      23
      12070272        34      18
      12071772        34      22
      15010075        27      16
      17740441        43      27
      17740468        52      33
      18367833        26      13
      18367863        29      16
      18367950        32      19
      18973094        39      27
      18976962        30      16
      18977299        20      8
      19000198        42      29
      19000214        40      26
      19898931        15      2
      19898945        13      2
      19898997        16      5
      19899206        37      24
      21293536        40      25
      21293836        26      15
      21294685        36      24

Based on this information (you can see clustering at certain 'hot
spots') I suspect that these are border effects in the regions where
chunking took place. Note also that scatter more often has *less*
reads which means we are missing reads because of edges (it is a BWA
thing).

Even so, even *with* these downsides, the method may work for rapid
diagnostics, provided the chunking affected FN/FP calls do not fall in
the regions of interest. For this setup, where time to diagnostic
counts (including cancer), it may prove a valuable approach. I also
suggest we find a way of setting chunking in regions of little
interest (outside coding genes and or regions of low variation as Brad
suggested).

