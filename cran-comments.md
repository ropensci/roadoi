
## Test environments

* local OS X install, R 3.4.1
* ubuntu 12.04 (on travis-ci), R 3.4.0
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

This submission implements suggestions made during the rOpenSci onboarding process. 

Thanks!

Najko Jahn
