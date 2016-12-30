# roadoi - Use oaDOI.org with R




[![Build Status](https://travis-ci.org/njahn82/roadoi.svg?branch=master)](https://travis-ci.org/njahn82/roadoi)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/njahn82/roadoi?branch=master&svg=true)](https://ci.appveyor.com/project/njahn82/roadoi)
[![codecov.io](https://codecov.io/github/njahn82/roadoi/coverage.svg?branch=master)](https://codecov.io/github/njahn82/roadoi?branch=master)

roadoi interacts with the [oaDOI service](http://oadoi.org/), which links DOIs 
and open access versions of scholarly works.

API Documentation: <http://oadoi.org/api>

## Installation

To install the development version, use the [devtools package](https://cran.r-project.org/web/packages/devtools/index.html)

```r
devtools::install_github("njahn82/roadoi")
library(roadoi)
```

## Usage

Use the `oadoi_fetch()` function in this package to get open access status
information and full-text links from oaDOI. Please note that oaDOI restricts
usage to 10k requests per day. If you need more, simply contact the 
[oaDOI team](https://oadoi.org/team). They will hook you up.


```r
roadoi::oadoi_fetch(dois = c("10.1038/ng.3260", "10.1093/nar/gkr1047"))
#> # A tibble: 2 × 11
#>                                                                      `_title`
#>                                                                         <chr>
#> 1                                       New genomes clarify mimicry evolution
#> 2 GABI-Kat SimpleSearch: new features of the Arabidopsis thaliana T-DNA mutan
#> # ... with 10 more variables: doi <chr>, doi_resolver <chr>,
#> #   evidence <chr>, free_fulltext_url <chr>, is_boai_license <lgl>,
#> #   is_free_to_read <lgl>, is_subscription_journal <lgl>, license <chr>,
#> #   oa_color <chr>, url <chr>
```


## Share your email address to support oaDOI!

oaDOI is provided by the non-profit [Impactstory](https://impactstory.org/). 
Sharing your email address with oaDOI does not only keep you updated in case 
something breaks, but also helps Impactstory reporting API usage to the non-profit's funders.


```r
roadoi::oadoi_fetch(dois = "10.1371/journal.pone.0018657", email = "name@example.com")
#> # A tibble: 1 × 11
#>                                                                      `_title`
#>                                                                         <chr>
#> 1 Who Shares? Who Doesn't? Factors Associated with Openly Archiving Raw Resea
#> # ... with 10 more variables: doi <chr>, doi_resolver <chr>,
#> #   evidence <chr>, free_fulltext_url <chr>, is_boai_license <lgl>,
#> #   is_free_to_read <lgl>, is_subscription_journal <lgl>, license <chr>,
#> #   oa_color <chr>, url <chr>
```


## Where to get DOIs from?

[rOpenSci](https://ropensci.org/) offers [various packages to access literature databases](https://ropensci.org/packages/#literature), and many of these packages return DOIs for scholarly works, if available.

A great tool to get a random sample set of DOIs is the 
[rcrossref](https://github.com/ropensci/rcrossref) package.

For instance, to get a random sample of 50 publications that are indexed by Crossref, a DOI-minting agency, and to explore how many of them are provided as green or gold open access:


```r
library(dplyr)
# get a random sample
dois_r <- rcrossref::cr_r(sample = 50)
# call oaDOI API
my_df <- roadoi::oadoi_fetch(dois_r)
# Analyse the so retrieved data 
my_df %>% 
  group_by(oa_color) %>%
  summarise(Articles = n()) %>%
  mutate(Proportion = Articles / sum(Articles)) %>%
  arrange(desc(Articles)) %>%
  knitr::kable()
```



|oa_color | Articles| Proportion|
|:--------|--------:|----------:|
|NA       |       42|       0.84|
|green    |        5|       0.10|
|gold     |        3|       0.06|

Following this approach, you can also easily assess how much oaDOI's data providers
contribute to its evidence base.



```r
my_df %>% 
  group_by(evidence) %>%
  summarise(Articles = n()) %>%
  mutate(Proportion = Articles / sum(Articles)) %>%
  arrange(desc(Articles)) %>%
  knitr::kable()
```



|evidence                                   | Articles| Proportion|
|:------------------------------------------|--------:|----------:|
|closed                                     |       42|       0.84|
|oa repository (via base-search.net oa url) |        5|       0.10|
|hybrid journal (via crossref license url)  |        3|       0.06|

## Meta

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

License: MIT

Please use the [issue tracker](https://github.com/njahn82/roadoi/issues) for bug reporting and feature requests.


