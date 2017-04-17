#' Fetch open access status information and full-text links from oaDOI
#'
#' This is the main function to retrieve comprehensive open acccess status
#' information from the oaDOI service. Please play nice with the API. At the
#' moment only 100k request are allowed per user and day.
#' For more info see \url{https://oadoi.org/api}.
#'
#' @param dois character vector, search by a single DOI or many DOIs.
#'   A rate limit of 100k requests per day is suggested. If you need to access
#'   more data, use the data dump \url{https://oadoi.org/api#dataset} instead.
#' @param email character vector, tell oaDOI your email adress to get notified
#'   if something breaks. It also helps oaDOI to keep track of usage!
#' @param .progress Shows the \code{plyr}-style progress bar.
#'   Options are "none", "text", "tk", "win", and "time".
#'   See \code{\link[plyr]{create_progress_bar}} for details
#'   of each. By default, no progress bar is displayed.
#'
#' @return The result is a tibble with each row representing a publication and
#' and the following columns.
#'
#' \tabular{rll}{
#'  [,1] \tab `_best_open_url`   \tab link to free full-text \cr
#'  [,2] \tab `_closed_base_ids` \tab ids of oai metadata records with closed access
#'  full-text links collected by the Bielefeld Academic Search Engine (BASE) \cr
#'  [,3] \tab `_open_base_ids`   \tab  ids of oai metadata records with open access
#'  full-text links collected by the Bielefeld Academic Search Engine (BASE) \cr
#'  [,4] \tab `_open_urls`       \tab full-text url \cr
#'  [,5] \tab doi                \tab DOI \cr
#'  [,6] \tab doi_resolver       \tab DOI agency \cr
#'  [,7] \tab evidence           \tab A phrase summarizing the step of the
#'  open access detection process where the full-text links were found. \cr
#'  [,8] \tab free_fulltext_url  \tab URL where the free version was found \cr
#'  [,9] \tab is_boai_license    \tab TRUE whenever the license indications are Creative
#'  Commons - Attribution (CC BY), Creative Commons CC - Universal(CC 0)) or Public
#'  Domain. These permissive licenses comply with the highly-regarded BOAI
#'  definition of Open access \cr
#' [,10] \tab is_free_to_read    \tab TRUE if freely available full-text was found
#'  \cr
#' [,11] \tab is_subscription_journal \tab TRUE if article is published in
#' toll-access journal \cr
#' [,12] \tab license      \tab Contains the name of the Creative Commons license
#' associated with the free_fulltext_url, whenever one was found. \cr
#' [,13] \tab oa_color           \tab OA delivered by journal (gold) or
#' by repository (green) \cr
#' [,14] \tab url                \tab the canonical DOI UR \cr
#' [,15] \tab year               \tab publishing year \cr
#' }
#'
#' The columns \code{`_closed_base_ids`}, \code{`_open_base_ids`}, \code{`_open_urls`},
#'  are list-columns and may have multiple entries.
#'
#' @examples \dontrun{
#' oadoi_fetch("10.1016/j.shpsc.2013.03.020")
#' oadoi_fetch(dois = c("10.1016/j.jbiotec.2010.07.030",
#' "10.1186/1471-2164-11-245"))
#' }
#'
#' @export
oadoi_fetch <-
  function(dois = NULL,
           email = NULL,
           .progress = "none") {
    # limit
    if (length(dois) > api_limit)
      stop(
        "A rate limit of 100k requests per day is suggested.
        If you need to access tomore data, use the data dump
        https://oadoi.org/api#dataset instead",
        .call = FALSE
      )
    plyr::ldply(dois, oadoi_fetch_, .progress = .progress) %>%
      dplyr::as_data_frame()
  }

#' Get open access status information.
#'
#' In general, use oadoi_fetch instead. It calls this method, returning open
#' access status information from all your requests.
#' @param doi character vector,a DOI
#' @param email character verctor, tell oaDOI your email adress to get notified
#'   if something breaks. It also helps oaDOI to keep track of usage!
#' @return A tibble
#' @examples \dontrun{
#' oadoi_fetch_(doi = c("10.1016/j.jbiotec.2010.07.030"))
#' }
#' @export
oadoi_fetch_ <- function(doi = NULL, email = NULL) {
  u <- httr::modify_url(oadoi_baseurl(),
                        query = args_(email = email),
                        path = doi)
  resp <- httr::GET(u,
                    ua,
                    # be explicit about the API version roadoi has to request
                    add_headers(
                      Accept = paste0("application/x.oadoi.",
                                      oadoi_api_version(), "+json")
                    ), timeout(10))

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
  }
  jsonlite::fromJSON(content(resp, "text", encoding = "UTF-8"))$results
}
