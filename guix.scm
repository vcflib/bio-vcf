;; To use this file to build HEAD of bio-vcf:
;;
;;   guix build -f guix.scm
;;
;; To get a development container (emacs shell will work)
;;
;;   rm Gemfile.lock # remove any dependencies
;;   guix environment -C -l guix.scm
;;   ruby ./bin/bio-vcf
;;
;;   rake test # for testing
;;   rake rdoc # for generating docs

(use-modules
  ((guix licenses) #:prefix license:)
  (guix gexp)
  (guix packages)
  (guix git-download)
  (guix build-system ruby)
  (guix build-system trivial)
  (gnu packages ruby)
  (gn packages ruby)
  (srfi srfi-1)
  (ice-9 popen)
  (ice-9 rdelim))

(define %source-dir (dirname (current-filename)))

(define %git-commit
    (read-string (open-pipe "git show HEAD | head -1 | cut -d ' ' -f 2" OPEN_READ)))

(define-public bio-vcf-source
  (package
    (name "bio-vcf-source")
    (version (git-version "0.9.5" "HEAD" %git-commit))
    (source (local-file %source-dir #:recursive? #t))
    (build-system trivial-build-system)
    (propagated-inputs
     `(("ruby" ,ruby)
       ("ruby-rake" ,ruby-rake)))
    (native-inputs
     `(("ruby-cucumber" ,ruby-cucumber)
    ))
    (arguments
     `(#:modules ((guix build utils))
       #:builder
       (begin
         (use-modules (guix build utils))
         (let ((target (string-append (assoc-ref %outputs "out")
                                      "/share")))
           (write target)
           (mkdir-p target)
           #t))))
    (synopsis "Smart VCF parser DSL")
    (description
     "Bio-vcf provides a @acronym{DSL, domain specific language} for processing
the VCF format.  Record named fields can be queried with regular expressions.
Bio-vcf is a new generation VCF parser, filter and converter.  Bio-vcf is not
only very fast for genome-wide (WGS) data, it also comes with a filtering,
evaluation and rewrite language and can output any type of textual data,
including VCF header and contents in RDF and JSON.")
    (home-page "http://github.com/vcflib/bio-vcf")
    (license license:expat)))


bio-vcf-source
