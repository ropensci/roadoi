# roadoi - Use Unpaywall with R



[![R build status](https://github.com/ropensci/roadoi/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci/roadoi/actions)
[![Build Status](https://travis-ci.org/ropensci/roadoi.svg?branch=master)](https://travis-ci.org/ropensci/roadoi)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropensci/roadoi?branch=master&svg=true)](https://ci.appveyor.com/project/ropensci/roadoi)
[![codecov.io](https://codecov.io/github/ropensci/roadoi/coverage.svg?branch=master)](https://codecov.io/github/ropensci/roadoi?branch=master)
[![cran version](http://www.r-pkg.org/badges/version/roadoi)](https://cran.r-project.org/package=roadoi)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/roadoi)](https://github.com/metacran/cranlogs.app)
[![review](https://badges.ropensci.org/115_status.svg)](https://github.com/ropensci/onboarding/issues/115)



roadoi interacts with the [Unpaywall API](http://unpaywall.org/products/api), 
a simple web-interface which links DOIs and open access versions of scholarly works. 
The API powers [Unpaywall](http://unpaywall.org/).

This client supports the most recent API Version 2.

API Documentation: <http://unpaywall.org/products/api>

## How do I use it? 

Use the `oadoi_fetch()` function in this package to get open access status
information and full-text links from Unpaywall.



```r
roadoi::oadoi_fetch(dois = c("10.1038/ng.3260", "10.1093/nar/gkr1047"), 
                    email = "najko.jahn@gmail.com")
#> # A tibble: 2 x 18
#>   doi   best_oa_location oa_locations data_standard is_oa genre oa_status
#>   <chr> <list>           <list>               <int> <lgl> <chr> <chr>    
#> 1 10.1… <tibble [1 × 11… <tibble [1 …             2 TRUE  jour… green    
#> 2 10.1… <tibble [1 × 9]> <tibble [7 …             2 TRUE  jour… gold     
#> # … with 11 more variables: has_repository_copy <lgl>, journal_is_oa <lgl>,
#> #   journal_is_in_doaj <lgl>, journal_issns <chr>, journal_issn_l <chr>,
#> #   journal_name <chr>, publisher <chr>, title <chr>, year <chr>, updated <chr>,
#> #   authors <list>
```

There are no API restrictions. However, providing an email address is required and a rate limit of 100k is suggested. If you need to access more data, use the [data dump](https://unpaywall.org/products/snapshot) instead.

### RStudio Addin

This package also has a RStudio Addin for easily finding free full-texts in RStudio.

![](man/figures/oadoi_addin.gif)

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



Open access copies of scholarly publications are sometimes hard to find. Some are published in open access journals. Others are made freely available as preprints before publication, and others are deposited in institutional repositories, digital archives maintained by universities and research institutions. This document guides you to roadoi, a R client that makes it easy to search for these open access copies by interfacing the [Unpaywall](https://unpaywall.org/) service where DOIs are matched with freely available full-texts available from open access journals and archives.

### About Unpaywall

[Unpaywall](https://unpaywall.org/), developed and maintained by the [team of Impactstory](https://profiles.impactstory.org/about), is a non-profit service that finds open access copies of scholarly literature simply by looking up a DOI (Digital Object Identifier). It not only returns open access full-text links, but also helpful metadata about the open access status of a publication such as licensing or provenance information.

Unpaywall uses different data sources to find open access full-texts including:

- [Crossref](http://www.crossref.org/): a DOI registration agency serving major scholarly publishers.
- [Directory of Open Access Journals (DOAJ)](https://doaj.org/): a registry of open access journals
- Various OAI-PMH metadata sources. OAI-PMH is a protocol often used by open access journals and repositories such as arXiv and PubMed Central.

See [Piwowar et al. (2018)](https://doi.org/10.7717/peerj.4375) for a comprehensive overview of Unpaywall.

### Basic usage

There is one major function to talk with Unpaywall, `oadoi_fetch()`, taking a character vector of DOIs and your email address as required arguments.


```r
library(roadoi)
roadoi::oadoi_fetch(dois = c("10.1186/s12864-016-2566-9",
                             "10.1103/physreve.88.012814"), 
                    email = "najko.jahn@gmail.com")
#> # A tibble: 2 x 18
#>   doi   best_oa_location oa_locations data_standard is_oa genre oa_status
#>   <chr> <list>           <list>               <int> <lgl> <chr> <chr>    
#> 1 10.1… <tibble [1 × 9]> <tibble [6 …             2 TRUE  jour… gold     
#> 2 10.1… <tibble [1 × 9]> <tibble [2 …             2 TRUE  jour… hybrid   
#> # … with 11 more variables: has_repository_copy <lgl>, journal_is_oa <lgl>,
#> #   journal_is_in_doaj <lgl>, journal_issns <chr>, journal_issn_l <chr>,
#> #   journal_name <chr>, publisher <chr>, title <chr>, year <chr>, updated <chr>,
#> #   authors <list>
```

#### What's returned?

The client supports API version 2. According to the [Unpaywall Data Format](http://unpaywall.org/data-format), the following variables with the following definitions are returned:

**Column**|**Description**
|:------------|:----------------------------------------------
`doi`|DOI (always in lowercase)
`best_oa_location`|list-column describing the best OA location. Algorithm prioritizes publisher hosted content (e.g. Hybrid or Gold)
`oa_locations`|list-column of all the OA locations. 
`data_standard`|Indicates the data collection approaches used for this resource. `1` mostly uses Crossref for hybrid detection. `2` uses more comprehensive hybrid detection methods. 
`is_oa`|Is there an OA copy (logical)? 
`is_paratext`| Is the item an ancillary part of a journal, like a table of contents? See here for more information <https://support.unpaywall.org/support/solutions/articles/44001894783>. 
`genre`|Publication type
`oa_status`|Classifies OA resources by location and license terms as one of: gold, hybrid, bronze, green or closed. See here for more information <https://support.unpaywall.org/support/solutions/articles/44001777288-what-do-the-types-of-oa-status-green-gold-hybrid-and-bronze-mean->.
`has_repository_copy`|Is a full-text available in a repository?
`journal_is_oa`|Is the article published in a fully OA journal? Uses the Directory of Open Access Journals (DOAJ) as source. 
`journal_is_in_doaj`|Is the journal listed in the Directory of Open Access Journals (DOAJ).
`journal_issns`|ISSNs, i.e. unique code to identify journals.
`journal_issn_l`|Linking ISSN.
`journal_name`|Journal title
`publisher`|Publisher
`published_date`|Date published
`year`|Year published. 
`title`|Publication title. 
`updated_resource`|Time when the data for this resource was last updated. 
`authors`|Lists authors (if available)

The columns  `best_oa_location` and  `oa_locations` are list-columns
that contain useful metadata about the OA sources found by Unpaywall These are

**Column**|**Description**
|:------------|:----------------------------------------------
`evidence`|How the OA location was found and is characterized by Unpaywall?
`host_type`|OA full-text provided by `publisher` or `repository`. 
`license`|The license under which this copy is published
`url`|The URL where you can find this OA copy.
`versions`|The content version accessible at this location following the DRIVER 2.0 Guidelines  (<https://wiki.surfnet.nl/display/DRIVERguidelines/DRIVER-VERSION+Mappings>)

Note that Unpaywall schema is only informally described. Check also with <https://unpaywall.org/data-format>.

There at least [two ways to simplify these list-columns](http://r4ds.had.co.nz/many-models.html#simplifying-list-columns).

To get the full-text links from the list-column `best_oa_location`, you may want to use `purrr::map_chr()`.


```r
library(dplyr)
roadoi::oadoi_fetch(dois = c("10.1186/s12864-016-2566-9",
                             "10.1103/physreve.88.012814"), 
                    email = "najko.jahn@gmail.com") %>%
  dplyr::mutate(
    urls = purrr::map(best_oa_location, "url") %>% 
                  purrr::map_if(purrr::is_empty, ~ NA_character_) %>% 
                  purrr::flatten_chr()
                ) %>%
  .$urls
#> [1] "https://bmcgenomics.biomedcentral.com/track/pdf/10.1186/s12864-016-2566-9"
#> [2] "https://link.aps.org/accepted/10.1103/PhysRevE.88.012814"
```

If you want to gather all full-text links and to explore where these links are hosted, simplify the list-column `oa_locations` with `tidyr::unnest()`. Note the  column `updated`, which belongs to the main data.frame and the nested list-column. It will cause an error when flatting into regular columns. Either de-select `updated` or change the argument `names_repair`.


```r
library(dplyr)
library(tidyr)
roadoi::oadoi_fetch(dois = c("10.1186/s12864-016-2566-9",
                             "10.1103/physreve.88.012814"), 
                    email = "najko.jahn@gmail.com") %>%
  tidyr::unnest(oa_locations) %>% 
  dplyr::mutate(
    hostname = purrr::map(url, httr::parse_url) %>% 
                  purrr::map_chr(., "hostname", .null = NA_integer_)
                ) %>% 
  dplyr::mutate(hostname = gsub("www.", "", hostname)) %>%
  dplyr::group_by(hostname) %>%
  dplyr::summarize(hosts = n())
#> Error: Names must be unique.
#> [31mx[39m These names are duplicated:
#>   * "updated" at locations 10 and 28.
#> [34mℹ[39m Use argument `names_repair` to specify repair strategy.
```


Note that fields to be returned might change according to the [Unpaywall API specs](http://unpaywall.org/products/api)

#### Any API restrictions?

There are no API restrictions. However, Unpaywall requires an email address when using its API. If you are too tired to type in your email address every time, you can store the email  in the `.Renviron` file with the option `roadoi_email` 

```
roadoi_email = "najko.jahn@gmail.com"
```.

You can open your `.Renviron` file calling 

```r
file.edit("~/.Renviron")`
```

Save the file and restart your R session. To stop sharing the email when using roadoi, delete it from your `.Renviron` file.

#### Keeping track of crawling

To follow your API call, and to estimate the time until completion, use the `.progress` parameter inherited from `plyr` to display a progress bar.


```r
roadoi::oadoi_fetch(dois = c("10.1186/s12864-016-2566-9",
                             "10.1103/physreve.88.012814"), 
                    email = "najko.jahn@gmail.com", 
                    .progress = "text")
#> 
  |                                                                                   
  |                                                                             |   0%
  |                                                                                   
  |======================================                                       |  50%
  |                                                                                   
  |=============================================================================| 100%
#> # A tibble: 2 x 18
#>   doi   best_oa_location oa_locations data_standard is_oa genre oa_status
#>   <chr> <list>           <list>               <int> <lgl> <chr> <chr>    
#> 1 10.1… <tibble [1 × 9]> <tibble [6 …             2 TRUE  jour… gold     
#> 2 10.1… <tibble [1 × 9]> <tibble [2 …             2 TRUE  jour… hybrid   
#> # … with 11 more variables: has_repository_copy <lgl>, journal_is_oa <lgl>,
#> #   journal_is_in_doaj <lgl>, journal_issns <chr>, journal_issn_l <chr>,
#> #   journal_name <chr>, publisher <chr>, title <chr>, year <chr>, updated <chr>,
#> #   authors <list>
```

#### Catching errors

Unpaywall is a reliable API. However, this client follows [Hadley Wickham's Best practices for writing an API package](https://CRAN.R-project.org/package=httr/vignettes/api-packages.html) and throws an error when the API does not return valid JSON or is not available. To catch these errors, you may want to use [purrr's `safely()`](https://purrr.tidyverse.org/reference/safely.html) function


```r
random_dois <-  c("ldld", "10.1038/ng.3260", "§dldl  ")
my_data <- purrr::map(random_dois, 
              .f = purrr::safely(function(x) roadoi::oadoi_fetch(x, email = "najko.jahn@gmail.com")))
# return results as data.frame
purrr::map_df(my_data, "result")
#> # A tibble: 1 x 18
#>   doi   best_oa_location oa_locations data_standard is_oa genre oa_status
#>   <chr> <list>           <list>               <int> <lgl> <chr> <chr>    
#> 1 10.1… <tibble [1 × 11… <tibble [1 …             2 TRUE  jour… green    
#> # … with 11 more variables: has_repository_copy <lgl>, journal_is_oa <lgl>,
#> #   journal_is_in_doaj <lgl>, journal_issns <chr>, journal_issn_l <chr>,
#> #   journal_name <chr>, publisher <chr>, title <chr>, year <chr>, updated <chr>,
#> #   authors <list>
#show errors
purrr::map(my_data, "error")
#> [[1]]
#> <simpleError: Unpaywall request failed [404]
#> 'ldld' isn't in Unpaywall. See https://support.unpaywall.org/a/solutions/articles/44001900286>
#> 
#> [[2]]
#> NULL
#> 
#> [[3]]
#> <simpleError: Unpaywall request failed [404]
#> '§dldl' isn't in Unpaywall. See https://support.unpaywall.org/a/solutions/articles/44001900286>
```

### Use Case: Studying the compliance with open access policies

An increasing number of universities, research organisations and funders have launched open access policies in recent years. Using roadoi together with other R-packages makes it easy to examine how and to what extent researchers comply with these policies in a reproducible and transparent manner. In particular, the [rcrossref package](https://github.com/ropensci/rcrossref), maintained by rOpenSci, provides many helpful functions for this task.

#### Gathering DOIs representing scholarly publications

DOIs have become essential for referencing scholarly publications, and thus many digital libraries and institutional databases keep track of these persistent identifiers. For the sake of this vignette, instead of starting with a pre-defined set of publications originating from these sources, we simply generate a random sample of 50 DOIs registered with Crossref by using the [rcrossref package](https://github.com/ropensci/rcrossref).


```r
library(dplyr)
library(rcrossref)
# get a random sample of DOIs and metadata describing these works
random_dois <- rcrossref::cr_r(sample = 50)
```

#### Calling Unpaywall

Now let's call Unpaywall. We are capturing possible errors.


```r
oa_df <- purrr::map(random_dois, .f = purrr::safely(
  function(x) roadoi::oadoi_fetch(x, email = "najko.jahn@gmail.com")
  )) %>%
  purrr::map_df("result")
```


#### Reporting

After obtaining the data, reporting with R is straightforward. You can even generate dynamic reports using [R Markdown](http://rmarkdown.rstudio.com/) and related packages, thus making your study reproducible and transparent.

To display how many full-text links were found and which sources were used in a nicely formatted markdown-table using the [`knitr`](https://yihui.name/knitr/)-package:


```r
if(!is.null(oa_df))
oa_df %>%
  group_by(is_oa) %>%
  summarise(Articles = n()) %>%
  mutate(Proportion = Articles / sum(Articles)) %>%
  arrange(desc(Articles)) %>%
  knitr::kable()
```



|is_oa | Articles| Proportion|
|:-----|--------:|----------:|
|FALSE |       33|       0.66|
|TRUE  |       17|       0.34|

How did Unpaywall find those Open Access full-texts, which were characterized as best matches, and how are these OA types distributed over publication types?


```r
if(!is.null(oa_df))
oa_df %>%
  filter(is_oa == TRUE) %>%
  select(best_oa_location, genre) %>%
  tidyr::unnest(best_oa_location) %>% 
  group_by(evidence, genre) %>%
  summarise(Articles = n()) %>%
  arrange(desc(Articles)) %>%
  knitr::kable()
```



|evidence                                |genre           | Articles|
|:---------------------------------------|:---------------|--------:|
|open (via page says license)            |journal-article |        8|
|oa repository (via OAI-PMH doi match)   |journal-article |        3|
|open (via free pdf)                     |journal-article |        3|
|oa journal (via observed oa rate)       |journal-article |        1|
|oa repository (semantic scholar lookup) |journal-article |        1|
|open (via free pdf)                     |component       |        1|

#### More examples

For more  examples, see Piwowar et al. 2018. Together with the article, the authors shared their analysis of Unpaywall Data as [R Markdown supplement](https://github.com/Impactstory/oadoi-paper1/).

This blog post describes how to analyze the Unpaywall data dump with R: <https://subugoe.github.io/scholcomm_analytics/posts/unpaywall_evidence/>

### References 

Piwowar, H., Priem, J., Larivière, V., Alperin, J. P., Matthias, L., Norlander, B., … Haustein, S. (2018). The state of OA: a large-scale analysis of the prevalence and impact of Open Access articles. PeerJ, 6, e4375. <https://doi.org/10.7717/peerj.4375>

## Meta

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/ropensci/roadoi/blob/master/CONDUCT.md). By participating in this project you agree to abide by its terms.

License: MIT

Please use the [issue tracker](https://github.com/ropensci/roadoi/issues) for bug reporting and feature requests.

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
