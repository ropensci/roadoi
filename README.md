
# roadoi - Use Unpaywall with R

[![R build
status](https://github.com/ropensci/roadoi/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci/roadoi/actions)
[![codecov.io](https://codecov.io/github/ropensci/roadoi/coverage.svg?branch=master)](https://codecov.io/github/ropensci/roadoi?branch=master)
[![cran
version](http://www.r-pkg.org/badges/version/roadoi)](https://cran.r-project.org/package=roadoi)
[![rstudio mirror
downloads](http://cranlogs.r-pkg.org/badges/roadoi)](https://github.com/r-hub/cranlogs.app)
[![review](https://badges.ropensci.org/115_status.svg)](https://github.com/ropensci/software-review/issues/115)

roadoi interacts with the [Unpaywall REST
API](https://unpaywall.org/products/api), an openly available
web-interface which returns metadata about open access versions of
scholarly works.

This client supports the most recent API Version 2.

API Documentation: <https://unpaywall.org/products/api>

## How do I use it?

Use the `oadoi_fetch()` function in this package to get open access
status information and full-text links from Unpaywall.

``` r
roadoi::oadoi_fetch(dois = c("10.1038/ng.3260", "10.1093/nar/gkr1047"), 
                    email = "najko.jahn@gmail.com")
#> # A tibble: 2 x 21
#>   doi      best_oa_location  oa_locations oa_locations_emb…
#>   <chr>    <list>            <list>       <list>           
#> 1 10.1038… <tibble [1 × 11]> <tibble [1 … <tibble [0 × 0]> 
#> 2 10.1093… <tibble [1 × 10]> <tibble [6 … <tibble [0 × 0]> 
#> # … with 17 more variables: data_standard <int>,
#> #   is_oa <lgl>, is_paratext <lgl>, genre <chr>,
#> #   oa_status <chr>, has_repository_copy <lgl>,
#> #   journal_is_oa <lgl>, journal_is_in_doaj <lgl>,
#> #   journal_issns <chr>, journal_issn_l <chr>,
#> #   journal_name <chr>, publisher <chr>,
#> #   published_date <chr>, year <chr>, title <chr>,
#> #   updated_resource <chr>, authors <list>
```

There are no API restrictions. However, providing an email address is
required and a rate limit of 100k is suggested. If you need to access
more data, use the [data dump](https://unpaywall.org/products/snapshot)
instead.

### RStudio Addin

This package also has a RStudio Addin for easily finding free full-texts
in RStudio.

![](man/figures/oadoi_addin.gif)

## How do I get it?

Install and load from [CRAN](https://cran.r-project.org/package=roadoi):

``` r
install.packages("roadoi")
library(roadoi)
```

To install the development version, use the [devtools
package](https://cran.r-project.org/package=devtools)

``` r
devtools::install_github("ropensci/roadoi")
library(roadoi)
```

## Documentation

See <https://docs.ropensci.org/roadoi/> to get started.

## Meta

Please note that this project is released with a [Contributor Code of
Conduct](https://github.com/ropensci/roadoi/blob/master/CONDUCT.md). By
participating in this project you agree to abide by its terms.

License: MIT

Please use the [issue
tracker](https://github.com/ropensci/roadoi/issues) for bug reporting
and feature requests.

[![ropensci\_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
