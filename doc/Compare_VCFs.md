# Comparing VCF files

Between two different pipeline runs we ended up with different VCF
files. The starting point (BAMs) was the same, but in each pipeline
different procedures may have been followed, i.e. the processing steps
for variant calling were not exactly the same. The first
freebayes+varscan2 pipeline (P1) I wrote after testing many callers
including somatic sniper and strelka, so I should know that well
enough. The second pipeline (P2) includes more variant callers. To
find out how they compared and which output was preferred I decided to
do some analysis using bio-vcf.

## Comparing freebayes output

The freebayes somatic variant calling files differed in size. Just
looking at one sample P1 had 479 lines and P2 had 729. The germline
calls, however, where comparable in size. But when I ran a diff it
showed these differed significantly too:

    wc -l germline*vcf
      3527 germline1.vcf
      3500 germline2.vcf
    cat germline1.vcf|bio-vcf -e "[r.chr,r.pos]"|sort > germline1.txt
    cat germline2.vcf|bio-vcf -e "[r.chr,r.pos]"|sort > germline2.txt
    diff germline1.txt germline2.txt |wc
       1751

To zoom in on settings, lets look at read depth on chromosome 7 (-v
and --num-threads=1 options I typically use when trying new filters
because they give digestable output):

    cat germline1.vcf|bio-vcf -v --num-threads 1 --filter 'rec.chr=="7"' -e '[r.chr,r.pos,r.info.dp]'|sort
        7       90225928        34
        7       95216394        69
        7       97821397        97
        7       97821398        98
        7       97822115        96
        7       97822210        94
        7       98503849        109
        7       98543545        68
        7       98543546        69
        7       98582562        38
        7       98650051        48
        7       99690690        78
        7       99690747        27
        7       99693552        34

    cat germline2.vcf|bio-vcf -v --num-threads 1 --filter 'rec.chr=="7"' -e '[r.chr,r.pos,r.info.dp]'|sort
        7       90225928        121
        7       95216394        534
        7       97822115        1053
        7       97822210        1044
        7       97834704        249
        7       98503849        1579
        7       98547176        59
        7       98553739        21
        7       98648517        75
        7       98650051        344
        7       99690690        455
        7       99690747        168
        7       99693552        107

OK, this is informative. P1 called variants after removing duplicate reads. P2
did not. That explains the different in number of variants called.

Unfortunately the sequencing concerns an FFPE dataset. FFPE degrades
over time and DNA changes. In itself this is not a problem because we
sequence many cells and the changed ones do not necessarily
dominate. We do, however, amplify the DNA before sequencing through a
PCR-type process. This means that randomly these FFPE changes may
become dominant at a certain position and variant callers score them
as genuine variants. I have studied this data and there is ample
evidence of this effect. The only way to address this is by removing
duplicate reads - so the amplified reads get compressed into one
(theoretically, because sometimes there are multiple errors confusing
things a bit). Removing duplicates is the *only* way and this can not
happen *after* variant calling.

This means P2 is out of the window. It is useless data also for the
other variant callers. I don't even have to check the somatic calling.

## Conclusion

A simple read depth check with bio-vcf proved that P2 had no
merit. Either we rerun it after removing duplicates or we rely on P1.
