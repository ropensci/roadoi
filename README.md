# roadoi - Use oaDOI.org with R




[![Build Status](https://travis-ci.org/ropensci/roadoi.svg?branch=master)](https://travis-ci.org/ropensci/roadoi)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropensci/roadoi?branch=master&svg=true)](https://ci.appveyor.com/project/ropensci/roadoi)
[![codecov.io](https://codecov.io/github/ropensci/roadoi/coverage.svg?branch=master)](https://codecov.io/github/ropensci/roadoi?branch=master)
[![cran version](http://www.r-pkg.org/badges/version/roadoi)](https://cran.r-project.org/package=roadoi)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/roadoi)](https://github.com/metacran/cranlogs.app)
[![review](https://badges.ropensci.org/115_status.svg)](https://github.com/ropensci/onboarding/issues/115)


roadoi interacts with the [oaDOI API](http://oadoi.org/), a simple interface which links DOIs 
and open access versions of scholarly works. oaDOI powers [unpaywall](http://unpaywall.org/).

This client supports the most recent API Version 2.

API Documentation: <http://oadoi.org/api/v2>

## How do I use it? 

Use the `oadoi_fetch()` function in this package to get open access status
information and full-text links from oaDOI.


```r
roadoi::oadoi_fetch(dois = c("10.1038/ng.3260", "10.1093/nar/gkr1047"), 
                    email = "name@example.com")
#> # A tibble: 2 x 13
#>                   doi best_oa_location     oa_locations data_standard
#>                 <chr>           <list>           <list>         <int>
#> 1     10.1038/ng.3260 <tibble [1 x 6]> <tibble [1 x 7]>             2
#> 2 10.1093/nar/gkr1047 <tibble [1 x 7]> <tibble [4 x 7]>             2
#> # ... with 9 more variables: is_oa <lgl>, journal_is_oa <lgl>,
#> #   journal_issns <chr>, journal_name <chr>, publisher <chr>, title <chr>,
#> #   year <int>, updated <chr>, non_compliant <list>
```

There are no API restrictions. However, providing an email address is required and a rate limit of 100k is implemented If you need to access more data, use the data dump <https://oadoi.org/api#dataset> instead.

### RStudio Addin

This package also has a RStudio Addin for easily finding free full-texts in RStudio.

![](inst/img/oadoi_addin.gif)

## How do I get it? 

Install and load from [CRAN](https://cran.r-project.org/package=roadoi):


```r
install.packages("roadoi")
library(roadoi)
```

To install the development version, use the [devtools package](https://cran.r-project.org/package=devtools)


```r
devtools::install_github("ropensci/roadoi")
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

See Piwowar, H., Priem, J., Larivière, V., Alperin, J. P., Matthias, L., Norlander, B., … Haustein, S. (2017). The State of OA: A large-scale analysis of the prevalence and impact of Open Access articles (Version 1). PeerJ Preprints. <https://doi.org/10.7287/peerj.preprints.3119v1> for a comprehensive overview of oaDOI.org.

### Basic usage

There is one major function to talk with oaDOI.org, `oadoi_fetch()`, taking DOIs and your email address as required arguments.


```r
library(roadoi)
roadoi::oadoi_fetch(dois = c("10.1186/s12864-016-2566-9",
                             "10.1016/j.cognition.2014.07.007"), 
                    email = "name@example.com")
#> # A tibble: 2 x 13
#>                               doi best_oa_location     oa_locations
#>                             <chr>           <list>           <list>
#> 1       10.1186/s12864-016-2566-9 <tibble [1 x 7]> <tibble [3 x 7]>
#> 2 10.1016/j.cognition.2014.07.007 <tibble [1 x 6]> <tibble [2 x 7]>
#> # ... with 10 more variables: data_standard <int>, is_oa <lgl>,
#> #   journal_is_oa <lgl>, journal_issns <chr>, journal_name <chr>,
#> #   publisher <chr>, title <chr>, year <int>, updated <chr>,
#> #   non_compliant <list>
```

#### What's returned?

The client supports API version 2. According to the [oaDOI.org API specification](https://oadoi.org/api/v2), the following variables with the following definitions are returned:
**Column**|**Description**
|:------------|:----------------------------------------------
`doi`|DOI (always in lowercase)
`best_oa_location`|list-column describing the best OA location. Algorithm prioritizes publisher hosted content (eg Hybrid or Gold)
`oa_locations`|list-column of all the OA locations. 
`data_standard`|Indicates the data collection approaches used for this resource. `1` mostly uses Crossref for hybrid detection. `2` uses more comprehensive hybrid detection methods. 
`is_oa`|Is there an OA copy (logical)? 
`journal_is_oa`|Is the article published in a fully OA journal? Uses the Directory of Open Access Journals (DOAJ) as source. 
`journal_issns`|ISSNs
`journal_name`|Journal title
`publisher`|Publisher
`title`|Publication title. 
`year`|Year published. 
`updated`|Time when the data for this resource was last updated. 
`non_compliant`|Lists other full-text resources that are not hosted by either publishers or repositories. 

The columns  `best_oa_location` and  `oa_locations` are list-columns
that contain useful metadata about the OA sources found by oaDOI. These are

**Column**|**Description**
|:------------|:----------------------------------------------
evidence`|How the OA location was found and is characterized by oaDOI?
host_type`|OA full-text provided by `publisher` or `repository`. 
license`|The license under which this copy is published
url`|The URL where you can find this OA copy.
versions`|The content version accessible at this location following the DRIVER 2.0 Guidelines evidence (<https://wiki.surfnet.nl/display/DRIVERguidelines/DRIVER-VERSION+Mappings>)

Note that fields to be returned might change according to the [oaDOI.org API specs](https://oadoi.org/api/v2)

#### Any API restrictions?

There are no API restrictions. However, providing your email address when using this client is required by oaDOI.org. Set email address in your `.Rprofile` file with the option `roadoi_email` when you are too tired to type in your email address every time you want to call oaDOI.org.

```r
options(roadoi_email = "name@example.com")
```

#### Keeping track of crawling

To follow your API call, and to estimate the time until completion, use the `.progress` parameter inherited from `plyr` to display a progress bar.


```r
roadoi::oadoi_fetch(dois = c("10.1186/s12864-016-2566-9",
                             "10.1016/j.cognition.2014.07.007"), 
                    email = "name@example.com", 
                    .progress = "text")
#>   |                                                                         |                                                                 |   0%  |                                                                         |================================                                 |  50%  |                                                                         |=================================================================| 100%
#> # A tibble: 2 x 13
#>                               doi best_oa_location     oa_locations
#>                             <chr>           <list>           <list>
#> 1       10.1186/s12864-016-2566-9 <tibble [1 x 7]> <tibble [3 x 7]>
#> 2 10.1016/j.cognition.2014.07.007 <tibble [1 x 6]> <tibble [2 x 7]>
#> # ... with 10 more variables: data_standard <int>, is_oa <lgl>,
#> #   journal_is_oa <lgl>, journal_issns <chr>, journal_name <chr>,
#> #   publisher <chr>, title <chr>, year <int>, updated <chr>,
#> #   non_compliant <list>
```

#### Catching errors

oaDOI is a reliable API. However, this client follows [Hadley Wickham's Best practices for writing an API package](https://CRAN.R-project.org/package=httr/vignettes/api-packages.html) and throws an error when API does not return valid JSON or is not available. To catch these errors, you may want to use [plyr's `failwith()`](https://www.rdocumentation.org/packages/plyr/versions/1.8.4/topics/failwith) function


```r
random_dois <-  c("ldld", "10.1038/ng.3260", "§dldl  ")
purrr::map_df(random_dois, 
              plyr::failwith(f = function(x) roadoi::oadoi_fetch(x, email ="name@example.com")))
#> # A tibble: 1 x 13
#>               doi best_oa_location     oa_locations data_standard is_oa
#>             <chr>           <list>           <list>         <int> <lgl>
#> 1 10.1038/ng.3260 <tibble [1 x 6]> <tibble [1 x 7]>             2  TRUE
#> # ... with 8 more variables: journal_is_oa <lgl>, journal_issns <chr>,
#> #   journal_name <chr>, publisher <chr>, title <chr>, year <int>,
#> #   updated <chr>, non_compliant <list>
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
#> # A tibble: 100 x 35
#>               alternative.id
#>                        <chr>
#>  1 10.1108/03684920010312821
#>  2                          
#>  3                          
#>  4                          
#>  5         S0033350631805657
#>  6         S0140670100967730
#>  7                          
#>  8                          
#>  9                          
#> 10                          
#> # ... with 90 more rows, and 34 more variables: container.title <chr>,
#> #   created <chr>, deposited <chr>, DOI <chr>, funder <list>,
#> #   indexed <chr>, ISBN <chr>, ISSN <chr>, issue <chr>, issued <chr>,
#> #   license_date <chr>, license_URL <chr>, license_delay.in.days <chr>,
#> #   license_content.version <chr>, link <list>, member <chr>, page <chr>,
#> #   prefix <chr>, publisher <chr>, reference.count <chr>, score <chr>,
#> #   source <chr>, subject <chr>, title <chr>, type <chr>, URL <chr>,
#> #   volume <chr>, assertion <list>, author <list>,
#> #   `clinical-trial-number` <list>, archive <chr>, update.policy <chr>,
#> #   subtitle <chr>, abstract <chr>
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
#> # A tibble: 37 x 2
#>    issued  pubs
#>     <dbl> <int>
#>  1   2016     8
#>  2   1999     6
#>  3   2010     6
#>  4   2015     6
#>  5     NA     6
#>  6   2007     5
#>  7   2013     5
#>  8   2014     5
#>  9   2000     4
#> 10   2012     4
#> # ... with 27 more rows
```

and of what type they are


```r
random_dois %>%
  group_by(type) %>%
  summarize(pubs = n()) %>%
  arrange(desc(pubs))
#> # A tibble: 7 x 2
#>                  type  pubs
#>                 <chr> <int>
#> 1     journal-article    71
#> 2        book-chapter    13
#> 3 proceedings-article    10
#> 4           component     3
#> 5                book     1
#> 6           monograph     1
#> 7     reference-entry     1
```

#### Calling oaDOI.org

Now let's call oaDOI.org


```r
oa_df <- roadoi::oadoi_fetch(dois = random_dois$DOI, email = "name@example.com")
```

and merge the resulting information about open access full-text links with parts of our Crossref metadata-set


```r
my_df <- random_dois %>%
  select(DOI, type) %>% 
  left_join(oa_df, by = c("DOI" = "doi"))
```

#### Reporting

After gathering the data, reporting with R is very straightforward. You can even generate dynamic reports using [R Markdown](http://rmarkdown.rstudio.com/) and related packages, thus making your study reproducible and transparent for others.

To display how many full-text links were found and which sources were used in a nicely formatted markdown-table using the [`knitr`](https://yihui.name/knitr/)-package:


```r
my_df %>%
  group_by(is_oa) %>%
  summarise(Articles = n()) %>%
  mutate(Proportion = Articles / sum(Articles)) %>%
  arrange(desc(Articles)) %>%
  knitr::kable()
```



|is_oa | Articles| Proportion|
|:-----|--------:|----------:|
|FALSE |       91|       0.91|
|TRUE  |        9|       0.09|

How did oaDOI find those Open Access full-texts, which were characterized as best matches.


```r
my_df %>%
  filter(is_oa == TRUE) %>%
  tidyr::unnest(best_oa_location) %>% 
  group_by(evidence) %>%
  summarise(Articles = n()) %>%
  mutate(Proportion = Articles / sum(Articles)) %>%
  arrange(desc(Articles)) %>%
  knitr::kable()
```



|evidence                         | Articles| Proportion|
|:--------------------------------|--------:|----------:|
|hybrid (via free pdf)            |        4|  0.4444444|
|oa journal (via publisher name)  |        2|  0.2222222|
|hybrid (via crossref license)    |        1|  0.1111111|
|oa repository (via BASE)         |        1|  0.1111111|
|oa repository (via pmcid lookup) |        1|  0.1111111|

Let's take a closer look and assess how these OA types are distributed over publication types?


```r
my_df %>%
  filter(is_oa == TRUE) %>%
  tidyr::unnest(best_oa_location) %>% 
  count(evidence, type, sort = TRUE) %>% 
  knitr::kable()
```



|evidence                         |type            |  n|
|:--------------------------------|:---------------|--:|
|hybrid (via free pdf)            |journal-article |  4|
|oa journal (via publisher name)  |component       |  2|
|hybrid (via crossref license)    |journal-article |  1|
|oa repository (via BASE)         |journal-article |  1|
|oa repository (via pmcid lookup) |journal-article |  1|


## Meta

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

License: MIT

Please use the [issue tracker](https://github.com/ropensci/roadoi/issues) for bug reporting and feature requests.

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
