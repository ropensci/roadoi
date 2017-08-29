#' Fetch open access status information and full-text links from oaDOI
#'
#' This is the main function to retrieve comprehensive open access status
#' information from the oaDOI service. Please play nice with the API. At the
#' moment only 100k request are allowed per user and day.
#' For more info see \url{https://oadoi.org/api}.
#'
#' @param dois character vector, search by a single DOI or many DOIs.
#'   A rate limit of 100k requests per day is suggested. If you need to access
#'   more data, use the data dump \url{https://oadoi.org/api#dataset} instead.
#' @param email character vector, required! It is strongly encourage to tell
#'   oaDOI your email address, so that they can track usage and notify you
#'   when something breaks. Set email address in your `.Rprofile` file with
#'   the option `roadoi_email` \code{options(roadoi_email = "name@example.com")}.
#' @param .progress Shows the \code{plyr}-style progress bar.
#'   Options are "none", "text", "tk", "win", and "time".
#'   See \code{\link[plyr]{create_progress_bar}} for details
#'   of each. By default, no progress bar is displayed.
#'
#' @return The result is a tibble with each row representing a publication and
#'   and the following columns. Here are some fields returned by the API.
#'   However, other fields can be added by oaDOI over time.
#'
#'
#' \tabular{ll}{
#'  \code{`_best_open_url`} \tab link to free full-text \cr
#'  \code{`_closed_base_ids`}   \tab internal ids for closed access copies \cr
#'  returned from the Bielefeld Academic Search Engine (BASE) \cr
#'  \code{`_closed_urls`}   \tab links to closed access copies \cr
#'  \code{`_green_base_collections`} \tab internal collection ID from the
#'  Bielefeld Academic Search Engine (BASE) \cr
#'  \code{`_open_base_ids`} \tab  ids of oai metadata records with open access
#'  full-text links collected by the Bielefeld Academic Search Engine (BASE) \cr
#'  \code{`_open_urls`}     \tab full-text url \cr
#'  \code{`_title`}         \tab title of the work \cr
#'  \code{doi}              \tab DOI \cr
#'  \code{doi_resolver}     \tab DOI agency \cr
#'  \code{evidence}         \tab A phrase summarizing the step of the
#'  open access detection process where the full-text links were found. \cr
#'  \code{found_green}      \tab logical indicating whether a self-archived
#'  copy in a repository was found \cr
#'  \code{found_hybrid}     \tab logical indicating whether an open access
#'  article was published in a toll-access journal \cr
#'  \code{free_fulltext_url}\tab URL where the free version was found \cr
#'  \code{is_boai_license}  \tab TRUE whenever the license indications are
#'  Creative Commons - Attribution (CC BY), Creative Commons CC - Universal(CC 0))
#'  or Public Domain. These permissive licenses comply with the
#'  highly-regarded Budapest Open Access Initiative (BOAI) definition of
#'  open access \cr
#'  \code{is_free_to_read}  \tab TRUE if freely available full-text
#'  was found \cr
#'  \code{is_subscription_journal} \tab TRUE if article is published in
#'  toll-access journal \cr
#'  \code{license}          \tab Contains the name of the Creative
#'  Commons license associated with the free_fulltext_url, whenever one
#'  was found. \cr
#'  \code{oa_color}         \tab OA delivered by journal (gold),
#'  by repository (green) or others (blue) \cr
#'  \code{oa_color_long}    \tab Long form of open access color \cr
#'  \code{reported_noncompliant_copies} \tab links to free full-texts found
#'  provided by service often considered as not open access compliant \cr
#'  \code{url}              \tab the canonical DOI UR \cr
#'  \code{year}             \tab publishing year \cr
#' }
#'
#' The columns  \code{`_closed_base_ids`},  \code{`_closed_urls`},
#' \code{`_open_base_ids`}, \code{`_open_urls`}, and
#' \code{`reported_noncompliant_copies`} are list-columns and may
#' have multiple entries.
#'
#' @examples \dontrun{
#' oadoi_fetch("10.1038/nature12373")
#' oadoi_fetch(dois = c("10.1016/j.jbiotec.2010.07.030",
#' "10.1186/1471-2164-11-245"))
#'
#' # you can unnest list-columns with tidyr:
#' tt %>%
#'   tidyr::unnest(open_base_ids)
#' }
#'
#' @export
oadoi_fetch <-
  function(dois = NULL,
           email = getOption("roadoi_email"),
           .progress = "none") {
    # limit
    # input validation
    stopifnot(!is.null(dois))
    email <- val_email(email)
    if (length(dois) > api_limit)
      stop(
        "A rate limit of 100k requests per day is suggested.
        If you need to access tomore data, use the data dump
        https://oadoi.org/api#dataset instead",
        .call = FALSE
      )
    # Call API for every DOI, and return results as tbl_df
    plyr::llply(dois, oadoi_fetch_, email, .progress = .progress) %>%
      dplyr::bind_rows()
  }

#' Get open access status information.
#'
#' In general, use \code{\link{oadoi_fetch}} instead. It calls this
#' method, returning open access status information from all your requests.
#'
#' @param doi character vector,a DOI
#' @param email character vector, required! It is strongly encourage to tell
#'   oaDOI your email adress, so that they can track usage and notify you
#'   when something breaks. Set email address in your `.Rprofile` file with
#'   the option `roadoi_email` \code{options(roadoi_email = "name@example.com")}.
#' @return A tibble
#' @examples \dontrun{
#' oadoi_fetch_(doi = c("10.1016/j.jbiotec.2010.07.030"))
#' }
#' @export
oadoi_fetch_ <- function(doi = NULL, email) {
  u <- httr::modify_url(
    oadoi_baseurl(),
    query = list(email = email),
    path = c(oadoi_api_version(), doi)
  )
  # Call oaDOI API
  resp <- httr::GET(u, ua)

  # test for valid json
  if (httr::http_type(resp) != "application/json") {
    # test needed because oaDOI throws 505 when non-encoded whitespace
    # is provided by this client
    stop(
      sprintf(
        "Oops, API did not return json after calling '%s':
        check your query - or api.oadoi.org may experience problems",
        doi
      ),
      call. = FALSE
    )
  }

  # warn if nothing could be found and return meaningful message
  if (httr::status_code(resp) != 200) {
    warning(
      sprintf(
        "oaDOI request failed [%s]\n%s",
        httr::status_code(resp),
        httr::content(resp)$message
      ),
      call. = FALSE
    )
    NULL
  } else {
    httr::content(resp, "text", encoding = "UTF-8") %>%
      jsonlite::fromJSON() %>%
      purrr::map(purrr::compact) %>% # remove empty list elements
      parse_oadoi()
  }
}

#' Parser for OADOI JSON
#'
#' @param req unparsed JSON
#'
#' @noRd
parse_oadoi <- function(req) {
  # be aware of empty list elements
  req <- purrr::map_if(req, is.null, ~ NA_character_)
  tibble::tibble(
    doi = req$doi,
    best_oa_location = list(as_data_frame(req$best_oa_location)),
    oa_locations = list(as_data_frame(req$oa_location)),
    data_standard = req$data_standard,
    is_oa = req$is_oa,
    journal_is_oa = ifelse(!is.null(req$journal_is_oa),
                           FALSE, req$journal_is_oa),
    journal_issns = req$journal_issns,
    journal_name = req$journal_name,
    publisher = req$publisher,
    title = req$title,
    year = req$year,
    updated = req$updated
  )
}
