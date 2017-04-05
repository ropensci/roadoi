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

This is my initial submission of roadoi for CRAN.

Thanks!

Najko Jahn
