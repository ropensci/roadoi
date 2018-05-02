
## Test environments

* local OS X El Captitan install, R 3.5.0
* on travis Ubuntu 14.04.5 LTS, R 3.5.0
* win-builder (release, devel and oldrelease) and appveyor CI

## R CMD check results

On local machine (OS X): OK

The win-builder send one NOTE about possibly mis-spelled words in DESCRIPTION,
which are, in fact, correctly spelled.

Win-builder (3.4.4) notes about non-standard role "rev" in Authors@R field.

## Reverse dependencies

* I have run R CMD check on downstream dependencies using devtools::revdep_check()
and found no problems related to this submission.

---

Dear CRAN maintainers, 

This submission is due to rebranding of oaDOI to Unpaywall Data. Besides update of documentation, this release provides improved handling of possible time-outs when calling the API. This fixes current CRAN check warnings.

Thanks!

Najko Jahn
