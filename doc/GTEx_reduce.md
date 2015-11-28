# Reduce number of GTEx SNPs

This exercise aims to reduce the number of SNPs in a GTEx VCF file
for the purpose of eQTL mapping. The original VCF is about 88 GB
and contains 11.5 million SNPs (included imputed SNPs)

We look at applying the following rules

1. Check for number of samples
2. If no call > 5% then delete
3. If the imputation r2 value is less than 0.3 throw the imputed SNP away
4. If the MAF is < 5% delete
5. If the r2 of LD is >.90 we can perhaps delete as redundant

The original VCF file is huge, so after (interrupted) unpacking reduce
it to ~250K lines for the purpose of fast testing turnaround:

    head -250000 /mnt/big/user/pjotr/gtex.vcf > gtex.vcf
    time wc gtex.vcf
    250000  114742296 1945309272 gtex.vcf
    real    0m24.592s
    user    0m24.197s
    sys     0m0.396s

which allows reading a 2GB file in half a minute.

Also created a 1000 line file to have even faster turnaround
named GTEx-tiny.vcf.

## Install bio-vcf

There are multiple ways to install bio-vcf. The preferred route
is to use GNU GUix. Basically, after installing guix, install 

    guix package -i ruby-bio-vcf

If that is not available (work in progress) install Ruby, set the
environment and install the bio-vcf gem.

    gem install bio-vcf

This should show

    bio-vcf -h

## Install pigz

For fast gz unpacking

    guix package -i pigz

## Check for number of genotypes (samples)

For locating QTL GTEx uses at least 70 samples per tissue to have
enough statistical power to map eQTL (out of 450 individuals). That is
RNA-seq data, not genotype data.

When a sample has a genotype the GT field is set, otherwise it looks
like './.' (i.e.. best Guessed Genotype with posterior probability
threshold of 0.9). E.g. with

     cat orig/GTEx-tiny.vcf ./bin/bio-vcf --eval '[r.chr,r.pos]' --seval 's.gt'
    1       900002  0/1     1/1     0/0     ./.     ./.     0/0     ./.     ./.     ./.      ./.     0/1     ./.     ./.     0/0     ./.     ./.     ./.     ./.     0/1      0/1     ./.     ./.     ./.     ./.     ./.     0/0     1/1     0/1     ./.      ./.     0/1     ./.     ./.     ./.     ./.     ./.     0/1

the matching posterior probability of the genotype looks like

    ./bin/bio-vcf --eval '[r.chr,r.pos]' --seval 's.gl.join(",")'

    1       899987  0.995,0.005,0   1.0,0,0 1.0,0,0 0.918,0.082,0   0.995,0.005,0   0.991,0.009,0   0.918,0.082,0   0.993,0.007,0   0.979,0.021,0   0.997,0.003,0   1.0,0,0 0.96,0.04,0     0.884,0.116,0   0.994,0.006,0   0.992,0.008,0   0.956,0.044,0   0.949,0.051,0   0.998,0.002,0 0.963,0.037,0   0.443,0.457,0.1 0.931,0.069,0   0.938,0.062,0   0.91,0.09,0     0.336,0.662,0.002       0.939,0.061,0   0.998,0.002,0   0.994,0.006,0   0.998,0.002,0   1.0,0,0 0.899,0.101,0   0.005,0.995,0   1.0,0,0 0.953,0.047,0   1.0,0,0 0.915,0.085,0

so calls are in there which have a low posterior probability.

We can also filter on samples called (which are not "./.") now with

    ./bin/bio-vcf --filter 'r.samples.count {|s| s.gt!="./."}>100' < orig/GTEx-tiny.vcf

which has minor impact, but does remove some. 

## If no call > 5% then delete

Lets check for genotypes called. This rule is more stringent

    ./bin/bio-vcf --eval '[(r.samples.count{|s| s.gt!="./."}>427)]'

stripped out about 50% of the calls (427 is 95\%).

## If the imputation r2 value is less than 0.3 throw the imputed SNP away

The number of imputed SNPS is around 90%.

Assuming this value is captured in info.impinfo ("Measure of the
observed statistical in formation associated with the allele frequency
estimate") we can do

    ./bin/bio-vcf --eval '[r.info.type == 0 && r.info.impinfo > 0.3]' < orig/GTEx-tiny.vcf

removes about 7% of calls (type 0 is imputed, actually we can skip this check
because impinfo is 1.0 for non-imputed). Increasing IMPINFO to 0.5 removes
10% of SNPs and 0.7 removes almost 40% of SNPs.

## If the MAF is < 5% delete

Calculating the minor allele frequency (MAF) is possible.  5% is a
good choice for a dataset this size unless we are looking for rare
SNPs (and we should keep all). Using the filter would suggest

    ./bin/bio-vcf --eval [r.chr,r.pos,r.filter,r.info.EXP_FREQ_A1]< orig/GTEx-tiny.vcf
    1       894573  PASS    0.809
    1       894719  maf05   0.015
    1       895037  maf05   0.022
    1       895268  maf05   0.037
    1       899000  maf05   0.024
    1       899928  PASS    0.867
    1       899937  PASS    0.826
    1       899938  PASS    0.831
    1       899942  PASS    0.835

that the MAF is actually the minor allele frequency here for smaller
values of EXP freq. This means we can filter on EXP

    ./bin/bio-vcf --filter 'r.info.exp_freq_a1 > 0.05' --eval [r.chr,r.pos,r.filter,r.info.EXP_FREQ_A1,r.info.type,r.info.impinfo] < orig/GTEx-tiny.vcf

which removes ~50% of calls. I caught SNPs that actually have an AF<0.05, e.g.

    1       759970  PASS    0.049   0       0.975

Maybe round-off error or a result of imputation.

## If the r2 of LD is >.90 we can perhaps delete as redundant

The VCF file contains an info field named HW or the "Hardy Weinberg
Equilibrium P value". The Hardy - Weinberg Equilibrium p<1x10-6 has
been calculated using the software tool SNPTEST. Filtering on HW:

    ./bin/bio-vcf --filter 'r.info.hw < 0.9' --eval [r.chr,r.pos,r.filter,r.info.EXP_FREQ_A1,r.info.type,r.info.impinfo,r.info.hw] < orig/GTEx-tiny.vcf|wc

reduces the set by about 60%. Filtering on 0.95 or 0.85 has little effect.
Simply filtering on <1.0 amounts to practically the same.

## Combining above rules

    ./bin/bio-vcf --filter 'r.info.exp_freq_a1 > 0.05 and r.info.exp_freq_a1 < 0.95 and r.info.impinfo > 0.3 and r.info.hw < 1.0 and (r.samples.count{|s| s.gt!="./."}>427)' --eval [r.chr,r.pos,r.filter,r.info.EXP_FREQ_A1,r.info.type,r.info.impinfo,r.info.hw] < orig/GTEx-tiny.vcf

Throws out ~83% of calls. Note, as discussed below, we are also throwing
out all SNPs with AF>0.95.

To get some sense of contributions:

Removing 'r.info.exp_freq_a1 > 0.05' throws out 55% of calls instead.

Removing 'r.info.exp_freq_a1 < 0.95' throws out 62% of calls instead.

Removing 'r.info.impinfo > 0.3' makes no difference.

Removing 'r.info.hw < 1.0' throws out 79% of calls instead.

Removing '(r.samples.count{|s| s.gt!="./."}>427)' throws out 62% of
calls instead.

In other words IMPINFO appears to be covered by the others and AF>0.95
is (largely) covered by the sample count.

## On imputed SNPs

Missing DNA data is pretty nasty when it comes to calculating SNPs (or
SNVs). Missing data is a result of missing or misaligned sequence
reads. Some samples (read individuals) do better than others, partly
due to noise (technical), distance from the reference genome (biology)
and structural variation in the genome (undiscovered INDELS). When one
has sequenced a population it is possible to impute missing data to
some degree. This is done through LD.

Here is a pretty good explanation how imputation is done:

  http://steventsnyder.com/projects/imputation/imputationtalk.pdf

For GTEx they used IMPUTE2

  http://www.nature.com/ng/journal/v44/n8/full/ng.2354.html

which does something pretty similar using 1000 genome Phase 3
(actually I would think the correct way to do this is to tie in
structural variation analysis and revisit the reads for every sample,
but that is a separate story/exercise).

An imputed SNP is actually a real SNP in some samples and a calculated
SNP in others. IMPUTE2 attaches a 'probability' for the
imputation. Say we have 20 real SNPs and 20 imputed SNPs, you'd expect
the probability to be 0.5. 40 real SNPs out of 40 would be 1.0 (it is
probably a bit more involved than that because sample size matters and
of course LD, but it should generally be like this). Simply throwing
away 20 real SNPs in the first case by default does not look right.

What I am proposing is to retain imputed SNPs based on their number
(higher is good) and the probability (higher is good). A number larger
than 20% and a probability higher than 0.8 could make sense. At the
same time, a high probability will reflect a high LD. So, for the
purpose of GWAS we could actually select the range 0.5<P<0.8 and throw
out the high LD.

### What does the VCF file give?

The IMPINFO field is described as the "Measure of the observed
statistical information associated with the allele frequency
estimate" and MISS is the "Missingness of SNP with posterior
probability threshold of 0.9". A list shows

    ./bin/bio-vcf --num-threads 1 --eval '[r.chr,r.pos,r.info.type,r.info.EXP_FREQ_A1,r.info.impinfo,r.info.miss,(r.samples.count{|s| s.gt!="./."})]'< GTEx-tiny.vcf
    1       897738  2       0.082   1.0     0.0     450
    1       897879  0       0.012   0.742   0.02    441
    1       898323  0       0.942   0.933   0.0244  439
    1       898467  0       0.044   0.982   0.0067  447
    1       899000  0       0.024   0.809   0.0356  434
    1       899928  0       0.867   0.821   0.1511  382
    1       899937  0       0.826   0.713   0.3511  292
    1       899938  0       0.831   0.731   0.3311  301
    1       899942  0       0.835   0.722   0.3311  301
    1       899949  0       0.046   0.87    0.0556  425
    1       899987  0       0.087   0.529   0.3067  312
    1       899989  0       0.873   0.758   0.2067  357
    1       900002  0       0.61    0.593   0.7222  125
    1       900057  0       0.049   0.56    0.1711  373

where type=2 is a SNP and type=0 is imputed. You can see that IMPINFO
is 1.0 for fully called SNPs (such as 897738). MISS correlates exactly
with the number of samples - MISS = 1-count_missing/total - so we can
replace the count filter with

    ./bin/bio-vcf --filter 'r.info.miss < 0.05 and r.info.exp_freq_a1 > 0.05 and r.info.exp_freq_a1 < 0.95 and r.info.impinfo > 0.3 and r.info.hw < 1.0 ' --eval '[r.chr,r.pos,r.filter,r.info.EXP_FREQ_A1,r.info.type,r.info.impinfo,r.info.hw,r.info.miss]' < orig/GTEx-tiny.vcf

which is quite a bit faster.

Column 4 (AF) and column 5 (IMPINFO) are the `informative'
columns. The 4th row shows an AF of 4.4% with IMPINFO 0.982, same for
the 3rd row. Meanwhile the 2nd row shows low AF scored in most of the
samples(!) and the imputation info is 0.742. What does it mean? Let's
get some detail

    ./bin/bio-vcf --num-threads 1 --eval '[r.chr,r.pos,r.info.type,r.info.EXP_FREQ_A1,r.info.impinfo,r.info.miss,(r.samples.count{|s| s.gt!="./."})]' --seval '[s.gt,s.gl[0]]' < GTEx-tiny.vcf
        1       897879  0       0.012   0.742   0.02    441     0/0     1.0     0/0     1.0
     0/0     1.0     0/0     1.0     ./.     0.45    0/0     1.0     0/0     1.0
     0/0     1.0     0/0     0.917   0/0     1.0     0/0     1.0     0/0     1.0
     0/0     1.0     0/0     1.0     0/0     0.997   0/0     1.0     0/0     1.0
     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0
     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0
     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0
     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0
     0/0     1.0     0/0     1.0     0/0     1.0     0/1     0.001   0/0     1.0
     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0
     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0
     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0
     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0     ./.     0.191
     0/0     0.999   ./.     0.718   0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0     0.996   0/0
     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0
     1.0     0/0     1.0     0/0     1.0     0/1     0.087   0/0     1.0     0/0
     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0     1.0     0/0
     1.0     0/0     1.0     0/0     0.995   0/0     0.999   0/0     1.0     0/0

It turns out the GL which is the posterior probability that a sample
matches a genotype defines whether a sample has been scored. You can
see that one sample was scored as genotype 0/1 with a posterior of
0.087 for the SNP genotype 0/0. Ther are also samples that have a
posterior <1.0, but they are few in this case.

When we look at 90002 we can see a more mixed up result:

    1       900002  0       0.61    0.593   0.7222  125     0/1     0.01    1/1     0       0/0     1.0     ./.     0       ./.     0.284   0/0     0.997   ./.     0.013   ./.     0.001   ./.     0.001   ./.     0.002   0/1     0.052   ./.     0.01    ./.     0.249   0/0     0.974   ./.     0.027   ./.     0.023   ./.     0.018   ./.     0.272   0/1     0.092   0/1     0.004   ./.     0.026   ./.     0.031   ./.     0.035   ./.     0.108   ./.     0.116   0/0     0.911   1/1     0       0/1

hardly the level of confidence we are looking for (IMPINFO is
0.6). Finally when looking at

    1       899942  0       0.835   0.722   0.3311  301     ./.     0.753   ./.     0.751   0/1     0       1/1     0.937   1/1     0.999   0/0     0       ./.     0.891   ./.     0.858   ./.     0.492   1/1     0.908   1/1     1       1/1     0.919   1/1     0.998   0/1     0.001   1/1     0.983   1/1     0.933   1/1     0.934   1/1     0.998   0/1     0       ./.     0       1/1     0.939   1/1     0.938   1/1     0.906   ./.     0       1/1     0.991   1/1     1       ./.     0.877   1/1

897879 and 899942 have similar IMPINFO (0.7)

For 897879 the number of '0/0' was 436 out of 441. The ones that had
a GL of 1.0 was 411. One score for imputation could be the number of samples
imputed, which would be 1-411/441 = 7%

And with

    ./bin/bio-vcf --num-threads 1 --eval '[r.chr,r.pos,r.info.type,r.info.EXP_FREQ_A1,r.info.impinfo,r.info.miss,(r.samples.count{|s| s.gt=="1/1" and s.gl[2]==1.0})]' < orig/GTEx-tiny.vcf

For 899942 the number of '1/1' was 238 out of 301. The ones that had a
GL of 1.0 was 76. The number of samples imputed would be 1-76/301 is
75%.

The IMPINFO shows no relationship with the number of samples
imputed. At least not in a way I would expect it. Looking online this
document

    http://static-content.springer.com/esm/art%3A10.1007%2Fs00125-014-3256-2/MediaObjects/125_2014_3256_MOESM3_ESM.pdf

suggests that the IMPINFO is r2. More on that below.

Meanwhile filtering on the number of genotypes scored with high
confidence using the GL could be interesting as a quality metric.

There is another parameter named certainty "Average certainty of best-guess genotypes". Let's try filtering on that.

    ./bin/bio-vcf --num-threads 1 --eval '[r.chr,r.pos,r.info.type,r.info.EXP_FREQ_A1,r.info.impinfo,r.info.certainty,(r.samples.count{|s| s.gt=="1/1" and s.gl[2]==1.0})]' --filter 'r.info.certainty>0.9' < orig/GTEx-tiny.vcf

removes 10% of SNPs. Trying it with the full filter, however, makes no
difference.

We'll try one more filter where we count the number of real SNPs first.

    ./bin/bio-vcf --eval '[r.chr,r.pos,r.samples.count { |s| (!s.empty? && s.gl[s.gtindex]==1.0) },r.samples.count{|s| s.gtindex!=nil}]'  < orig/GTEx-tiny.vcf
    1       898467  441     447
    1       899000  390     434
    1       899928  177     382
    1       899937  90      292
    1       899938  100     301
    1       899942  103     301
    1       899949  405     425
    1       899987  89      312
    1       899989  164     357
    1       900002  18      125
    1       900057  187     373
    1       900169  421     439

shows the high confidence SNPs and the number of SNPs called. Now we
play a bit with the settings. This being Ruby introduce some variables

    ./bin/bio-vcf --eval 'found=r.samples.count{|s| s.gt!="./."} ; real=r.samples.count { |s| (!s.empty? && s.gl[s.gtindex]==1.0) } ; [r.chr,r.pos,real,found]'  < orig/GTEx-tiny.vcf

Let's say we do not allow less than 70% real, i.e. real/found>0.7

    ./bin/bio-vcf --eval '[r.chr,r.pos,r.samples.count { |s| (!s.empty? && s.gl[s.gtindex]==1.0) },r.samples.count{|s| s.gt!="./."}]' --filter 'r.samples.count { |s| (!s.empty? && s.gl[s.gtindex]==1.0) }.to_f/r.samples.count{|s| s.gt!="./."}>0.7' < orig/GTEx-tiny.vcf

reduces the set by 35%.

Also we don't want more than 30 actual imputed values. That means

    ./bin/bio-vcf --eval '[r.chr,r.pos,r.samples.count { |s| (!s.empty? && s.gl[s.gtindex]==1.0) },r.samples.count{|s| s.gt!="./."}]' --filter 'found=r.samples.count { |s| (!s.empty? && s.gl[s.gtindex]==1.0) }.to_f; total=r.samples.count{|s| s.gt!="./."} ; total-found<30' < orig/GTEx-tiny.vcf

reduces the set by 60%. Increasing that value to 50 makes it 50%.

Filling it in the original filter we are now down to 13%:

    ./bin/bio-vcf --filter 'found=r.samples.count { |s| (!s.empty? && s.gl[s.gtindex]==1.0) }.to_f; total=r.samples.count{|s| s.gt!="./."} ; r.info.miss < 0.05 and found/total>0.7 and total-found<30 and r.info.exp_freq_a1 > 0.05 and r.info.exp_freq_a1 < 0.95 and r.info.impinfo > 0.7 and r.info.hw < 1.0' --eval [r.chr,r.pos,r.filter,r.info.EXP_FREQ_A1,r.info.type,r.info.impinfo,r.info.hw] < orig/GTEx-tiny.vcf

and speeding it up a bit with lambda:

    ./bin/bio-vcf --filter '((r.info.miss<0.05 and r.info.exp_freq_a1>0.05 and r.info.exp_freq_a1<0.95 and r.info.impinfo>0.7 and r.info.hw<1.0) ? (lambda { found=r.samples.count { |s| (!s.empty? && s.gl[s.gtindex]==1.0) }.to_f; total=r.samples.count{|s| s.gt!="./."} ; found/total>0.7 and total-found<30 }.call) : false)' < orig/GTEx-tiny.vcf

### Further digging on IMPINFO

GTEx Science paper suggests

    https://www.sciencemag.org/content/suppl/2015/05/06/348.6235.648.DC1/GTEx.SM.pdf

(IMP)INFO is the imputation quality score coming out of
IMPUTE2. According to their manual INFO is a measure of the observed
statistical information associated with the allele frequency estimate
(hopefully before imputation). See also

    https://mathgen.stats.ox.ac.uk/impute/impute_v2.html#info_metric_details

This metric is similar to the r2 reported by other programs like MaCH
and Beagle. Although each of these metrics is defined differently,
they tend to be correlated.

Our metric typically takes values between 0 and 1, where values near 1
indicate that a SNP has been imputed with high certainty. The metric
can occasionally take negative values when the imputation is very
uncertain, and we automatically assign a value of -1 when the metric
is undefined (e.g., because it wasn't calculated).

Investigators often use the info metric to remove poorly imputed SNPs
from their association testing results. There is no universal cutoff
value for post-imputation SNP filtering; various groups have used
cutoffs of 0.3 and 0.5, for example, but the right threshold for your
analysis may differ. One way to assess different info thresholds is to
see whether they produce sensible Q-Q plots, although we emphasize
that Q-Q plots can look bad for many reasons besides your
post-imputation filtering scheme.

This Sciencemag GTEx.SM.pdf document says: For eQTL analysis,
following imputation, we filtered out the following SNPs: missing rate
cutoff <95% for best - guessed genotypes at posterior probability>0.9,
Hardy - Weinberg Equilibrium p<1x10-6 (using the software tool
SNPTEST, imputation confidence score, INFO<0.4, and minor allele
frequency, MAF<5%.  This yielded 6,820,471 genotyped and imputed
autosomal SNPs.

I should be able to replicate this filter (all this data is in the VCF
file). 7 million SNPs is still a lot for our purposes. When looking at
my analysis I think we should increase IMPINFO to 0.7. The threshold
at 0.5 shows a lot of variability.

## On common SNPs (or rare variants)

Common SNPs are SNPs that occur in a large part of the
population. Often these SNPs simply reflect a variant not seen in the
reference genome (otherwise they would not even be scored!) and can
therefore be considered harmless (no effect). In general practice
these SNPs are thrown out of studies that look into biomedical
effects.

For GWAS, however, a common SNP wich correlates perfectly with some
phenotype *is* of interest. If 95% of SNPs correlates with some gene
expression it *could* be involved in regulation, for example. Throwing
such a SNP out is throwing out the baby with the bath water.

Interestingly in GTEx 75% of SNPs are common SNPs (450 genotyped
individuals, threshold 90%). It would be really nice to throw these
out from a data handling and computational angle, but I suspect it is
not a great idea.

Common SNPs are those that are scored in >95% of the population. This
does mean that the other variants are rare. min(p,1-p) would be a good
approximation - p can contain one variant or more, depending.
Removing rare SNPs (now defined) is an interesting one.  Do we throw
the baby out with the bathwater? That is a valid question. Also,
since we don't score reference alleles, we may miss out on a number
of those too.

Still, with rare diseases, for example, in a population of 450 you'd
be lucky to find one SNP. And one single SNP certainly won't hold for
significance.

I think we'd be OK to set the threshold to 5% (and 95%) for the
purpose of eQTL mapping.

## Final filtering

Using pigz to unpack the gzip file we can see how fast bio-vcf is
(effectively bio-vcf uses 10 cores here)

    pigz -c -d /mnt/big/GTEXv6_20151023/GTEx_Analysis_20150112_OMNI_2.5M_5M_450Indiv_chr1to22_genot_imput_info04_maf01_HWEp1E6_ConstrVarIDs.vcf.gz |/usr/bin/time -v |
    ./bin/bio-vcf --thread-lines 40000 --filter 'r.info.miss < 0.05 and r.info.exp_freq_a1 > 0.05 and r.info.exp_freq_a1 < 0.95 r.info.certainty>0.9 and r.info.impinfo > 0.7 and r.info.hw < 1.0'  --eval [r.chr,r.pos,r.filter,r.info.EXP_FREQ_A1,r.info.type,r.info.impinfo,r.info.hw,r.info.miss]
    User time (seconds): 4004.84
    System time (seconds): 209.98
    Percent of CPU this job got: 980%
    Elapsed (wall clock) time (h:mm:ss or m:ss): 7:09.99

and speedwise bio-vcf compares favourably even to a bare pigz+wc

    /usr/bin/time -v pigz -c -d /mnt/big/GTEXv6_20151023/GTEx_Analysis_20150112_OMNI_2.5M_5M_450Indiv_chr1to22_genot_imput_info04_maf01_HWEp1E6_ConstrVarIDs.vcf.gz|wc
    User time (seconds): 346.61
    System time (seconds): 183.30
    Percent of CPU this job got: 44%
    Elapsed (wall clock) time (h:mm:ss or m:ss): 19:48.18

(wc is maxing out at 100% CPU). The original VCF contains 11.5 million
SNPs (88 GB uncompressed VCF) and our filter rendered 4676425 SNPs.
The number of SNPs we have now is about 4.5 million (40% of the
total).

Adding the imputation filter (so not allowing a large percentage of
SNPs being calculated) reduces the file with

    pigz -c -d /mnt/big/GTEXv6_20151023/GTEx_Analysis_20150112_OMNI_2.5M_5M_450Indiv_chr1to22_genot_imput_info04_maf01_HWEp1E6_ConstrVarIDs.vcf.gz |/usr/bin/time -v ./bin/bio-vcf --filter 'found=r.samples.count { |s| (!s.empty? && s.gl[s.gtindex]==1.0) }.to_f; total=r.samples.count{|s| s.gt!="./."} ; r.info.miss < 0.05 and found/total>0.7 and total-found<30 and r.info.exp_freq_a1 > 0.05 and r.info.exp_freq_a1 < 0.95 and r.info.impinfo > 0.7 and r.info.hw < 1.0' --eval [r.chr,r.pos,r.filter,r.info.EXP_FREQ_A1,r.info.type,r.info.impinfo,r.info.hw] > test2.vcf

This command maxed out on 32-cores. It does a greedy count, so I
reduced the number of thread-lines and rearranged the order a bit by
postponing sample counts:
    
    pigz -c -d /mnt/big/GTEXv6_20151023/GTEx_Analysis_20150112_OMNI_2.5M_5M_450Indiv_chr1to22_genot_imput_info04_maf01_HWEp1E6_ConstrVarIDs.vcf.gz |/usr/bin/time -v ./bin/bio-vcf --thread-lines 10000 --filter '((r.info.miss<0.05 and r.info.exp_freq_a1>0.05 and r.info.exp_freq_a1<0.95 and r.info.impinfo>0.7 and r.info.hw<1.0) ? (lambda { found=r.samples.count { |s| (!s.empty? && s.gl[s.gtindex]==1.0) }.to_f; total=r.samples.count{|s| s.gt!="./."} ; found/total>0.7 and total-found<30 }.call) : false)' 
        User time (seconds): 125002.18
        System time (seconds): 1324.05
        Percent of CPU this job got: 2913%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 1:12:16

that worked with a whopping 29 core usage taking 1hr and 12 min
resulting in 3.9 million SNPS. This throws away imputed SNPs which may
still be of interest. In the following we test AF for real calls and
throw away imputed SNPs that have more than 30% calculated:

    pigz -c -d /mnt/big/GTEXv6_20151023/GTEx_Analysis_20150112_OMNI_2.5M_5M_450Indiv_chr1to22_genot_imput_info04_maf01_HWEp1E6_ConstrVarIDs.vcf.gz |/usr/bin/time -v ./bin/bio-vcf --thread-lines 10000 --filter '((r.info.miss<0.05 and r.info.exp_freq_a1>0.05 and r.info.exp_freq_a1<0.95 and r.info.impinfo>0.7 and r.info.hw<1.0) ? (lambda { found=r.samples.count { |s| (!s.empty? && s.gl[s.gtindex]==1.0) }.to_f; total=r.samples.count{|s| s.gt!="./."} ; af=found/450 ; af>0.05 and af < 0.95 and found/total>0.3 }.call) : false)' --eval [r.chr,r.pos,r.filter,r.info.EXP_FREQ_A1]
        User time (seconds): 124262.48
        System time (seconds): 1236.51
        Percent of CPU this job got: 2879%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 1:12:38

Now the number of SNPs have dropped to 1.2 million(!). This is very
interesting.  So, if we calculate the AF using truly called genotypes
it drops significantly (even allowing 70% of genotypes to be
imputed).

Now, to make sure we don't remove fully called SNPs we need to add one
more test for r.info.type>0 just to ascertain no SNPs marked as fixed
get thrown away (should be slightly faster too)

    pigz -c -d /mnt/big/GTEXv6_20151023/GTEx_Analysis_20150112_OMNI_2.5M_5M_450Indiv_chr1to22_genot_imput_info04_maf01_HWEp1E6_ConstrVarIDs.vcf.gz |/usr/bin/time -v ./bin/bio-vcf --thread-lines 10_000 --filter '((r.info.miss<0.05 and r.info.exp_freq_a1>0.05 and r.info.exp_freq_a1<0.95 and r.info.impinfo>0.7 and r.info.hw<1.0) ? ((r.info.type>0 and r.info.exp_freq_a1>0.05 and r.info.exp_freq_a1<0.95) or lambda { found=r.samples.count { |s| (!s.empty? && s.gl[s.gtindex]==1.0) }.to_f; total=r.samples.count{|s| s.gt!="./."} ; af=found/450 ; af>0.05 and af < 0.95 and found/total>0.3 }.call) : false)' --eval [r.chr,r.pos,r.filter,r.info.EXP_FREQ_A1] > t4a.txt

This is an impressive one-liner which, unlike Perl-style one-liners,
is still readable and does a lot of work normally captured in one-off
scripts.
