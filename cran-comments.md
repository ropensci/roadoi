
## Test environments

* local OS X install, R 3.4.1
* ubuntu 12.04 (on travis-ci), R 3.4.0
* win-builder (release, devel and oldrelease) and appveyor CI

## R CMD check results

General:

This submission implements suggestions made during the rOpenSci onboarding process. To
acknowledge the reviewer, I used the `rev` to  seperate it from the contributors role.

This results in 2 NOTEs when running `R CMD Check --as-cran`

```
* checking DESCRIPTION meta-information ... NOTE
Authors@R field gives persons with non-standard roles:
  Tuija Sonkkila [rev] (Tuija Sonkkila 
    reviewed the package for rOpenSci, 
    see https://github.com/ropensci/onboarding/issues/115): rev
  Ross Mounce [rev] (Ross Mounce
    reviewed the package for rOpenSci, 
    see https://github.com/ropensci/onboarding/issues/115): rev
```

On local machine (OS):

In addition, the win-builder send one NOTE about possibly mis-spelled words in DESCRIPTION,
which are, in fact, correctly spelled.

## Reverse dependencies

* I have run R CMD check on downstream dependencies using devtools::revdep_check()
and found no problems related to this submission.

---

Dear CRAN maintainers, 

This submission implements suggestions made during the rOpenSci onboarding process. 

There is currently one warning on CRAN Package Check Results for roadoi (r-release-windows-ix86+x86_64)
saying:

```
Version: 0.2 
Check: re-building of vignette outputs 
Result: WARN 
    Error in re-building vignettes:
     ...
    
    Attaching package: 'dplyr'
    
    The following objects are masked from 'package:stats':
    
     filter, lag
    
    The following objects are masked from 'package:base':
    
     intersect, setdiff, setequal, union
    
    Quitting from lines 129-130 (intro.Rmd) 
    Error: processing vignette 'intro.Rmd' failed with diagnostics:
    Timeout was reached
    Execution halted 
Flavor: r-release-windows-ix86+x86_64
```

Thanks!

Najko Jahn
