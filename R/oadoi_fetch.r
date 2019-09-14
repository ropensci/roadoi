#' Fetch open access status information and full-text links using Unpaywall
#'
#' This is the main function to retrieve comprehensive open access status
#' information from Unpaywall data service. Please play nice with the API.
#' For each user, 100k calls per day are suggested. If you need to access
#' more data, there is also a data dump available.
#' For more info see \url{https://unpaywall.org/products/snapshot}.
#'
#' @param dois character vector, search by a single DOI or many DOIs.
#'   A rate limit of 100k requests per day is suggested. If you need to access
#'   more data, request the data dump \url{https://unpaywall.org/dataset} instead.
#' @param email character vector, mandatory! Unpaywall requires your email address,
#'   so that they can track usage and notify you when something breaks.
#'   Set email address in your `.Rprofile` file with
#'   the option `roadoi_email` \code{options(roadoi_email = "najko.jahn@gmail.com")}.
#' @param .progress Shows the \code{plyr}-style progress bar.
#'   Options are "none", "text", "tk", "win", and "time".
#'   See \code{\link[plyr]{create_progress_bar}} for details
#'   of each. By default, no progress bar is displayed.
#'
#' @return The result is a tibble with each row representing a publication.
#'   Here are the returned columns and descriptions according to the API docu:
#'
#'
#' \tabular{ll}{
#'  \code{doi}              \tab DOI (always in lowercase). \cr
#'  \code{best_oa_location} \tab list-column describing the best OA location.
#'  Algorithm prioritizes publisher hosted content (eg Hybrid or Gold),
#'  then prioritizes versions closer to the  version of record (PublishedVersion
#'  over AcceptedVersion), then more authoritative  repositories (PubMed Central
#'  over CiteSeerX). \cr
#'  \code{oa_locations}     \tab list-column of all the OA locations. \cr
#'  \code{data_standard}    \tab Indicates the data collection approaches used
#'  for this resource. \code{1} mostly uses Crossref for hybrid detection. \code{2}
#'  uses more comprehensive hybrid detection methods. \cr
#'  \code{is_oa}            \tab Is there an OA copy (logical)? \cr
#'  \code{genre}            \tab Publication type \cr
#'  \code{oa_status}        \tab Classifies OA resources by location and license terms as one of: gold, hybrid, bronze, green or closed. See here for more information \url{https://support.unpaywall.org/support/solutions/articles/44001777288-what-do-the-types-of-oa-status-green-gold-hybrid-and-bronze-mean-}. \cr
#'  \code{has_repository_copy} \tab Is a full-text available in a repository? \cr
#'  \code{journal_is_oa}    \tab Is the article published in a fully OA journal? \cr
#'  \code{journal_is_in_doaj} \tab Is the journal listed in
#'   the Directory of Open Access Journals (DOAJ). \cr
#'  \code{journal_issns}    \tab ISSNs, i.e. unique numbers to identify
#'  journals. \cr
#'  \code{journal_issns_l}    \tab Linking ISSN. \cr
#'  \code{journal_name}     \tab Journal title, not normalized. \cr
#'  \code{publisher}        \tab Publisher, not normalized. \cr
#'  \code{title}            \tab Publication title. \cr
#'  \code{year}             \tab Year published. \cr
#'  \code{published_date}   \tab Date published. \cr
#'  \code{updated}          \tab Time when the data for this resource was last updated. \cr
#'  \code{authors}          \tab Lists author information (if available). \cr
#' }
#'
#' The columns  \code{best_oa_location} and  \code{oa_locations} are list-columns
#' that contain useful metadata about the OA sources found by Unpaywall.
#'
#' These are:
#'
#' \tabular{ll}{
#'  \code{evidence}        \tab How the OA location was found and is characterized
#'   by Unpaywall? \cr
#'  \code{host_type}       \tab OA full-text provided by \code{publisher} or
#'   \code{repository}. \cr
#'  \code{license}         \tab The license under which this copy is published,
#'   e.g. Creative Commons license. \cr
#'  \code{url}             \tab The URL where you can find this OA copy. \cr
#'  \code{versions}        \tab The content version accessible at this location
#'   following the DRIVER 2.0 Guidelines
#'  (\url{https://wiki.surfnet.nl/display/DRIVERguidelines/DRIVER-VERSION+Mappings}\cr
#' }
#'
#'
#' To unnest list-columns, you want to use tidyr's unnest function
#' \code{\link[tidyr]{unnest}}.
#'
#' Note that Unpaywall schema is only informally described.
#' Check also \url{https://unpaywall.org/data-format}.

#' @examples \dontrun{
#' oadoi_fetch("10.1038/nature12373", email = "name@example.com")
#' oadoi_fetch(dois = c("10.1016/j.jbiotec.2010.07.030",
#' "10.1186/1471-2164-11-245"), email = "name@example.com")
#' }
#'
#' @export
oadoi_fetch <-
  function(dois = NULL,
           email = getOption("roadoi_email"),
           .progress = "none") {
    # input validation
    stopifnot(!is.null(dois))
    # remove empty characters
    if (any(dois %in% "")) {
      dois <- dois[dois != ""]
      warning("Removed empty characters from DOI vector")
    }
    email <- val_email(email)
    if (length(dois) > api_limit)
      stop(
        "A rate limit of 100k requests per day is suggested.
        If you need to access more data, request the data dump
        https://unpaywall.org/dataset",
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
#'   Unpaywall your email adress, so that they can track usage and notify you
#'   when something breaks. Set email address in your `.Rprofile` file with
#'   the option `roadoi_email` \code{options(roadoi_email = "name@example.com")}.
#' @return A tibble
#' @examples \dontrun{
#' oadoi_fetch_(doi = c("10.1016/j.jbiotec.2010.07.030"))
#' }
#' @export
oadoi_fetch_ <- function(doi = NULL, email = NULL) {
  u <- httr::modify_url(
    oadoi_baseurl(),
    query = list(email = email),
    path = c(oadoi_api_version(), trimws(doi))
  )
  # Call Unpaywall Data API
  resp <- httr::RETRY("GET", u, ua)

  # test for valid json
  if (httr::http_type(resp) != "application/json") {
    # test needed because Unpaywall throws 505 when non-encoded whitespace
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

  # error if nothing could be found and return meaningful message
  if (httr::status_code(resp) != 200) {
    stop(
      sprintf(
        "Unpaywall request failed [%s]\n%s",
        httr::status_code(resp),
        httr::content(resp)$message
      ),
      call. = FALSE
    )
    NULL
  } else {
    httr::content(resp, "text", encoding = "UTF-8") %>%
      jsonlite::fromJSON() %>%
      purrr::map_if(is.null, ~ NA_character_) %>%
      parse_oadoi()
  }
}

#' Parser for Unpaywall Data JSON
#'
#' @param req unparsed JSON
#'
#' @noRd
parse_oadoi <- function(req) {
  # be aware of empty list elements
  tibble::tibble(
    doi = req$doi,
    best_oa_location = list(oa_lct_parser(req$best_oa_location)),
    oa_locations = list(tibble::as_tibble(req$oa_location)),
    data_standard = req$data_standard,
    is_oa = req$is_oa,
    genre = req$genre,
    oa_status = req$oa_status,
    has_repository_copy = req$has_repository_copy,
    journal_is_oa = as.logical(ifelse(
      is.na(req$journal_is_oa),
      FALSE, req$journal_is_oa
    )),
    journal_is_in_doaj = as.logical(ifelse(
      is.na(req$journal_is_in_doaj),
      FALSE, req$journal_is_in_doaj
    )),
    journal_issns = req$journal_issns,
    journal_issn_l = req$journal_issn_l,
    journal_name = req$journal_name,
    publisher = req$publisher,
    title = req$title,
    year = as.character(req$year),
    updated = req$updated,
    authors = list(req$z_authors)
  )
}

#' Parse best oa locations
#'
#' @param x list element
#'
#' @noRd
oa_lct_parser <- function(x) {
  if (!length(x) == 1) {
    purrr::compact(x) %>%
      dplyr::bind_rows()
    } else {
    tibble::tibble()
  }
}
