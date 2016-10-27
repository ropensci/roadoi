# roadoi - Use oaDOI.org with R




[![Build Status](https://travis-ci.org/njahn82/roadoi.svg?branch=master)](https://travis-ci.org/njahn82/roadoi)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/njahn82/roadoi?branch=master&svg=true)](https://ci.appveyor.com/project/njahn82/roadoi)
[![codecov.io](https://codecov.io/github/njahn82/roadoi/coverage.svg?branch=master)](https://codecov.io/github/njahn82/roadoi?branch=master)

roadoi interacts with the [oaDOI service](http://oadoi.org/), which links DOIs 
and open access versions of scholarly works.

API Documentation: <http://oadoi.org/api>

## Installation

Development version:

```r
devtools::install_github("njahn82/roadoi")
library(roadoi)
```

## Usage

Use the `oadoi_fetch()` function in this package to get open access status
information and full-text links from oaDOI. Please note that oaDOI restricts
usage to 10k requests per day.


```r
roadoi::oadoi_fetch(dois = c("10.1038/ng.3260", "10.1093/nar/gkr1047"))
#> # A tibble: 2 x 10
#>                   doi doi_resolver
#> *               <chr>        <chr>
#> 1     10.1038/ng.3260     crossref
#> 2 10.1093/nar/gkr1047     crossref
#> # ... with 8 more variables: evidence <chr>, free_fulltext_url <chr>,
#> #   is_boai_license <lgl>, is_free_to_read <lgl>,
#> #   is_subscription_journal <lgl>, license <chr>, oa_color <chr>,
#> #   url <chr>
```

## Where to get DOIs?

[rOpenSci](https://ropensci.org/) offers [various packages to access literature databases](https://ropensci.org/packages/#literature), and many of these packages return DOIs for scholarly works, if available.

A great tool to get a random sample of DOI is the 
[rcrossref](https://github.com/ropensci/rcrossref) package.

For instance, to get a DOI sample of 50 publications, and explore how many 
publications are provided as green or gold open access:


```r
library(dplyr)
dois_r <- rcrossref::cr_r(sample = 50)
roadoi::oadoi_fetch(dois_r) %>% 
  group_by(oa_color) %>%
  summarise(Articles = n()) %>%
  knitr::kable()
```



|oa_color | Articles|
|:--------|--------:|
|gold     |        9|
|green    |        2|
|NA       |       39|


## Meta

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

License: MIT

Please use the issue tracker for bug reporting and feature requests.

