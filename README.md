# roadoi - Use oaDOI.org with R




[![Build Status](https://travis-ci.org/njahn82/roadoi.svg?branch=master)](https://travis-ci.org/njahn82/roadoi)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/njahn82/roadoi?branch=master&svg=true)](https://ci.appveyor.com/project/njahn82/roadoi)
[![codecov.io](https://codecov.io/github/njahn82/roadoi/coverage.svg?branch=master)](https://codecov.io/github/njahn82/roadoi?branch=master)

roadoi interacts with the [oaDOI service](http://oadoi.org/), which links DOIs 
and open access versions of scholarly works.

API Documentation: <http://oadoi.org/api>

## How do I use it? 

Use the `oadoi_fetch()` function in this package to get open access status
information and full-text links from oaDOI. Please note that oaDOI restricts
usage to 10k requests per day. If you need more, simply contact the 
[oaDOI team](https://oadoi.org/team). They will hook you up.


```r
roadoi::oadoi_fetch(dois = c("10.1038/ng.3260", "10.1093/nar/gkr1047"))
#> # A tibble: 2 × 16
#>   `_match_simple_norm_distance` `_match_title_score`
#>                           <dbl>                <dbl>
#> 1                             1                    1
#> 2                            NA                   NA
#> # ... with 14 more variables: `_match_type` <chr>,
#> #   `_match_uses_first_author` <lgl>, `_year` <int>, doi <chr>,
#> #   doi_resolver <chr>, evidence <chr>, free_fulltext_url <chr>,
#> #   is_boai_license <lgl>, is_free_to_read <lgl>,
#> #   is_subscription_journal <lgl>, license <chr>, oa_color <chr>,
#> #   url <chr>, year <int>
```

## How do I get it? 

To install the development version, use the [devtools package](https://cran.r-project.org/web/packages/devtools/index.html)


```r
devtools::install_github("njahn82/roadoi")
library(roadoi)
```

## Long-Form Documentation including use-case



Open access copies of scholarly publications are sometimes hard to find. Some are published in open access journals. Others are made freely available as preprints before publication, and others are deposited in institutional repositories, digital archives maintained by universities and research institutions. This document guides you to roadoi, a R client that makes it easy to search for these open access copies by interfacing the [oaDOI.org](https://oadoi.org/) service where DOIs are matched with full-text links in open access journals and archives.

### About oaDOI.org

[oaDOI.org](https://oadoi.org/), developed and maintained by the [team of Impactstory](https://oadoi.org/team), is a non-profit service that finds open access copies of scholarly literature simply by looking up a DOI (Digital Object Identifier). It not only returns open access full-text links, but also helpful metadata about the open access status of a publication such as licensing or provenance information.

oaDOI uses different data sources to find open access full-texts including:

- [Crossref](http://www.crossref.org/): a DOI registration agency serving major scholarly publishers.
- [Datacite](https://www.datacite.org/): another DOI registration agency with main focus on research data
- [Directory of Open Access Journals (DOAJ)](https://doaj.org/): a registry of open access journals
- [Bielefeld Academic Search Engine (BASE)](https://www.base-search.net/): an aggregator of various OAI-PMH metadata sources. OAI-PMH is a protocol often used by open access journals and repositories.

### Basic usage

There is one major function to talk with oaDOI.org, `oadoi_fetch()`, which takes up to 10,000 DOIs as input.


```r
library(roadoi)
roadoi::oadoi_fetch(dois = c("10.1186/s12864-016-2566-9", "10.1016/j.cognition.2014.07.007"))
#> # A tibble: 2 × 15
#>   `_match_simple_norm_distance` `_match_title_score` `_match_type`
#>                           <dbl>                <dbl>         <chr>
#> 1                            NA                   NA          <NA>
#> 2                             1                    1  title subset
#> # ... with 12 more variables: `_match_uses_first_author` <lgl>, doi <chr>,
#> #   doi_resolver <chr>, evidence <chr>, free_fulltext_url <chr>,
#> #   is_boai_license <lgl>, is_free_to_read <lgl>,
#> #   is_subscription_journal <lgl>, license <chr>, oa_color <chr>,
#> #   url <chr>, year <int>
```

According to the [oaDOI.org API specification](https://oadoi.org/api), the following variables with the following definitions are returned:

* `doi`: the requested DOI
* `doi_resolver`: Possible values:
    + crossref
    + datacite
* `evidence`: A phrase summarizing the step of the open access detection process where the `free_fulltext_url` was found.
* `free_fulltext_url`: The URL where we found a free-to-read version of the DOI. None when no free-to-read version was found.
* `is_boai_license`: TRUE whenever the license indications Creative Commons - Attribution (CC BY), Creative Commons  CC - Universal(CC 0)) or Public Domain were found. These permissive licenses comply with the highly-regarded [BOAI definition of Open access](http://www.budapestopenaccessinitiative.org/)
* `is_free_to_read`: TRUE whenever the free_fulltext_url is not None.
* `is_subscription_journal`: TRUE whenever the journal is not in the Directory of Open Access Journals or DataCite. Please note that there might be a time-lag between the first publication of an open access journal and its registration in the DOAJ.
* `license`: Contains the name of the [Creative Commons license](https://creativecommons.org/) associated with the `free_fulltext_url`, whenever one was found. Example: "cc-by".
* `oa_color`: Possible values:
    + green
    + gold
* `url`: the canonical DOI URL

Providing your email address when using this client is highly appreciated by oaDOI.org. It not only helps the maintainer of oaDOI.org, the non-profit [Impactstory](https://impactstory.org/), to inform you when something breaks, but also to demonstrate API usage to its funders. Simply use the `email` parameter for this purpose:


```r
roadoi::oadoi_fetch("10.1186/s12864-016-2566-9", email = "name@example.com")
#> # A tibble: 1 × 15
#>   `_match_simple_norm_distance` `_match_title_score` `_match_type`
#>                           <lgl>                <lgl>         <lgl>
#> 1                            NA                   NA            NA
#> # ... with 12 more variables: `_match_uses_first_author` <lgl>, doi <chr>,
#> #   doi_resolver <chr>, evidence <chr>, free_fulltext_url <chr>,
#> #   is_boai_license <lgl>, is_free_to_read <lgl>,
#> #   is_subscription_journal <lgl>, license <chr>, oa_color <chr>,
#> #   url <chr>, year <int>
```

oaDOI.org limits API usage to 10,000 requests per day. However, when you need an upgrade, please contact team@impactstory.org.

To follow your API call, and to estimate the time until completion, use the `.progress` parameter inherited from plyr to display a progress bar.


```r
roadoi::oadoi_fetch(dois = c("10.1186/s12864-016-2566-9", "10.1016/j.cognition.2014.07.007"), .progress = "text")
#>   |                                                                         |                                                                 |   0%  |                                                                         |================================                                 |  50%  |                                                                         |=================================================================| 100%
#> # A tibble: 2 × 15
#>   `_match_simple_norm_distance` `_match_title_score` `_match_type`
#>                           <dbl>                <dbl>         <chr>
#> 1                            NA                   NA          <NA>
#> 2                             1                    1  title subset
#> # ... with 12 more variables: `_match_uses_first_author` <lgl>, doi <chr>,
#> #   doi_resolver <chr>, evidence <chr>, free_fulltext_url <chr>,
#> #   is_boai_license <lgl>, is_free_to_read <lgl>,
#> #   is_subscription_journal <lgl>, license <chr>, oa_color <chr>,
#> #   url <chr>, year <int>
```

### Use Case: Studying the compliance with open access policies

An increasing number of universities, research organisations and funders have launched open access policies in recent years. Using roadoi together with other R-packages makes it easy to examine how and to what extent researchers comply with these policies in a reproducible and transparent manner. In particular, the [rcrossref package](https://github.com/ropensci/rcrossref), maintained by rOpenSci, provides many helpful functions for this task.

#### Gathering DOIs representing scholarly publications

DOIs have become essential for referencing scholarly publications, and thus many digital libraries and institutional databases keep track of these persistent identifiers. For the sake of this vignette, instead of starting with a pre-defined set of publications originating from these sources, we simply generate a random sample of 100 DOIs registered with Crossref by using the [rcrossref package](https://github.com/ropensci/rcrossref).


```r
library(dplyr)
library(rcrossref)
# get a random sample of DOIs and metadata describing these works
random_dois <- rcrossref::cr_r(sample = 100) %>%
  rcrossref::cr_works() %>%
  .$data
random_dois
#> # A tibble: 100 × 34
#>       alternative.id
#>                <chr>
#> 1      634112013-560
#> 2                   
#> 3                   
#> 4      598482009-001
#> 5  S0017931005003443
#> 6   009082589190113J
#> 7  S014067368590323X
#> 8                   
#> 9                   
#> 10                  
#> # ... with 90 more rows, and 33 more variables: container.title <chr>,
#> #   created <chr>, deposited <chr>, DOI <chr>, funder <list>,
#> #   indexed <chr>, ISBN <chr>, ISSN <chr>, issued <chr>, link <list>,
#> #   member <chr>, prefix <chr>, publisher <chr>, reference.count <chr>,
#> #   score <chr>, source <chr>, subject <chr>, subtitle <chr>, title <chr>,
#> #   type <chr>, URL <chr>, assertion <list>, author <list>,
#> #   `clinical-trial-number` <list>, issue <chr>, page <chr>, volume <chr>,
#> #   license_date <chr>, license_URL <chr>, license_delay.in.days <chr>,
#> #   license_content.version <chr>, update.policy <chr>, archive <chr>
```

Let's see when these random publications were published


```r
random_dois %>%
  # convert to years
  mutate(issued, issued = lubridate::parse_date_time(issued, c('y', 'ymd', 'ym'))) %>%
  mutate(issued, issued = lubridate::year(issued)) %>%
  group_by(issued) %>%
  summarize(pubs = n()) %>%
  arrange(desc(pubs))
#> # A tibble: 45 × 2
#>    issued  pubs
#>     <dbl> <int>
#> 1    2016     9
#> 2    2005     8
#> 3    2013     7
#> 4      NA     7
#> 5    2015     6
#> 6    2011     5
#> 7    1999     3
#> 8    2000     3
#> 9    2006     3
#> 10   2007     3
#> # ... with 35 more rows
```

and of what type they are


```r
random_dois %>%
  group_by(type) %>%
  summarize(pubs = n()) %>%
  arrange(desc(pubs))
#> # A tibble: 6 × 2
#>                  type  pubs
#>                 <chr> <int>
#> 1     journal-article    83
#> 2        book-chapter     7
#> 3             dataset     4
#> 4 proceedings-article     4
#> 5           component     1
#> 6              report     1
```

#### Calling oaDOI.org

Now let's call oaDOI.org


```r
oa_df <- roadoi::oadoi_fetch(dois = random_dois$DOI)
```

and merge the resulting information about open access full-text links with our Crossref metadata-set


```r
my_df <- dplyr::left_join(oa_df, random_dois, by = c("doi" = "DOI"))
my_df
#> # A tibble: 100 × 50
#>    `_match_simple_norm_distance` `_match_title_score` `_match_type`
#>                            <dbl>                <dbl>         <chr>
#> 1                             NA                   NA          <NA>
#> 2                             NA                   NA          <NA>
#> 3                              1                    1  title subset
#> 4                             NA                   NA          <NA>
#> 5                             NA                   NA          <NA>
#> 6                             NA                   NA          <NA>
#> 7                             NA                   NA          <NA>
#> 8                              1                    1  title subset
#> 9                             NA                   NA          <NA>
#> 10                            NA                   NA          <NA>
#> # ... with 90 more rows, and 47 more variables:
#> #   `_match_uses_first_author` <lgl>, doi <chr>, doi_resolver <chr>,
#> #   evidence <chr>, free_fulltext_url <chr>, is_boai_license <lgl>,
#> #   is_free_to_read <lgl>, is_subscription_journal <lgl>, license <chr>,
#> #   oa_color <chr>, url <chr>, year <int>, error <chr>,
#> #   error_message <lgl>, alternative.id <chr>, container.title <chr>,
#> #   created <chr>, deposited <chr>, funder <list>, indexed <chr>,
#> #   ISBN <chr>, ISSN <chr>, issued <chr>, link <list>, member <chr>,
#> #   prefix <chr>, publisher <chr>, reference.count <chr>, score <chr>,
#> #   source <chr>, subject <chr>, subtitle <chr>, title <chr>, type <chr>,
#> #   URL <chr>, assertion <list>, author <list>,
#> #   `clinical-trial-number` <list>, issue <chr>, page <chr>, volume <chr>,
#> #   license_date <chr>, license_URL <chr>, license_delay.in.days <chr>,
#> #   license_content.version <chr>, update.policy <chr>, archive <chr>
```

#### Reporting

After gathering the data, reporting with R is very straightforward. You can even generate dynamic reports using [R Markdown](http://rmarkdown.rstudio.com/) and related packages, thus making your study reproducible and transparent for others.

To display how many full-text links were found and which sources were used in a nicely formatted markdown-table using the [`knitr`](https://yihui.name/knitr/)-package:


```r
my_df %>%
  group_by(evidence) %>%
  summarise(Articles = n()) %>%
  mutate(Proportion = Articles / sum(Articles)) %>%
  arrange(desc(Articles)) %>%
  knitr::kable()
```



|evidence                                        | Articles| Proportion|
|:-----------------------------------------------|--------:|----------:|
|closed                                          |       83|       0.83|
|oa repository (via base-search.net oa url)      |        8|       0.08|
|oa journal (via journal title in doaj)          |        5|       0.05|
|oa repository (via base-search.net scraped url) |        2|       0.02|
|oa journal (via publisher name)                 |        1|       0.01|
|oa repository (via pmcid lookup)                |        1|       0.01|

How many of them are provided as green or gold open access?


```r
my_df %>%
  group_by(oa_color) %>%
  summarise(Articles = n()) %>%
  mutate(Proportion = Articles / sum(Articles)) %>%
  arrange(desc(Articles)) %>%
  knitr::kable()
```



|oa_color | Articles| Proportion|
|:--------|--------:|----------:|
|NA       |       83|       0.83|
|green    |       11|       0.11|
|gold     |        6|       0.06|

Let's take a closer look and assess how green and gold is distributed over publication types?


```r
my_df %>%
  filter(!evidence == "closed") %>% 
  count(oa_color, type, sort = TRUE) %>% 
  knitr::kable()
```



|oa_color |type            |  n|
|:--------|:---------------|--:|
|green    |journal-article | 11|
|gold     |journal-article |  5|
|gold     |component       |  1|


## Meta

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

License: MIT

Please use the [issue tracker](https://github.com/njahn82/roadoi/issues) for bug reporting and feature requests.

