
## Test environments

* local OS X install, R 3.4.0
* ubuntu 12.04 (on travis-ci), R 3.4.0
* win-builder (release, devel and oldrelease) and appveyor CI

## R CMD check results

On local machine (OS):

Status: OK

The win-builder send one NOTE about possibly mis-spelled words in DESCRIPTION,
which are, in fact, correctly spelled.

## Reverse dependencies

* I have run R CMD check on downstream dependencies using devtools::revdep_check()
and found no problems related to this submission.

---

Dear CRAN maintainers, 

This submission implements the most recent API version, and includes new features including a RStudio Addin. 

There is currently one warning on CRAN Package Check Results for roadoi (r-release-osx-x86_64) saying 

"Result: WARN 
    Error in re-building vignettes:
     ...
    Warning in engine$weave(file, quiet = quiet, encoding = enc) :
     Pandoc (>= 1.12.3) and/or pandoc-citeproc not available. Falling back to R Markdown v1.
    Quitting from lines 64-65 (intro.Rmd) 
    Error: processing vignette 'intro.Rmd' failed with diagnostics:
    Timeout was reached
    Execution halted 
"

At least building the vignette should work now.

Thanks!

Najko Jahn
