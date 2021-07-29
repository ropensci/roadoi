
## Test environments

- local Mac OS BigSur install (11.4), R version 4.1.0 (2021-05-18)
- GitHub Actions: windows-latest (release), macOS-latest (release), ubuntu-20.04 (release), ubuntu-20-04 (devel)
- CRAN Win Builder

## R CMD check results

On local machine (Mac OS): OK

win-builder (R-release, R-oldrelease, R-devel): OK

## Reverse dependencies

I have run R CMD check on downstream dependencies using revdepcheck::revdep_check(num_workers = 4) and found no problems related to this submission.

---

Dear CRAN maintainers, 

This submission fixes the problems shown on
<https://cran.r-project.org/web/checks/check_results_roadoi.html>.

Thanks for alerting me!

Najko Jahn
