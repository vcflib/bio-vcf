## ChangeLog v0.9.5 (20210118)

+ Improved README and installation instructions
+ Added guix.scm build and instructions (no need for bundler)
+ Moved regressiontest into tree

## ChangeLog v0.9.4 (20201222)

This is an important maintenance release of bio-vcf:

+ Rename bioruby-vcf to bio-vcf and migrate project to [vcflib](https://github.com/vcflib/bio-vcf)
+ Fixed tests to match recent Ruby updates

## Older release notes

+ Getting ready for a 1.0 release
+ Released 0.9.2 as a gem
+ 0.9.1 removed a rare threading bug and cleanup on error
+ Added support for soft filters (request by Brad Chapman)
+ The outputter now writes (properly) in parallel with the parser
+ bio-vcf turns any VCF into JSON with header information, and
  allows you to pipe that JSON directly into any JSON supporting
  language, including Python and Javascript!

## Older changes

For older changes view the git [log](https://github.com/vcflib/bio-vcf/commits/master).
