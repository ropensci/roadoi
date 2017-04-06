# roadoi initial submission v 0.1

## Test environments

* local OS X install, R 3.3.2
* ubuntu 12.04 (on travis-ci), R 3.3.2
* win-builder (devel and release) and appveyor CI

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

This is a re-submission because the package did not pass the CRAN teams' auto-check service: There was a web API timeout while building the vignettes. This version now waits up to 5 seconds using the httr::timeout function.

This is my initial submission of roadoi for CRAN.

Thanks!

Najko Jahn
