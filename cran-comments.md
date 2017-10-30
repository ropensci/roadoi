
## Test environments

* local OS X install, R 3.4.2
* ubuntu 12.04 (on travis-ci), R 3.4.2
* win-builder (release, devel and oldrelease) and appveyor CI

## R CMD check results

On local machine (OS X): OK

The win-builder send one NOTE about possibly mis-spelled words in DESCRIPTION,
which are, in fact, correctly spelled.

## Reverse dependencies

* I have run R CMD check on downstream dependencies using devtools::revdep_check()
and found no problems related to this submission.

---

Dear CRAN maintainers, 

This submission includes minor bug fixes, and fixes current CRAN checks warning messages.

Thanks!

Najko Jahn
