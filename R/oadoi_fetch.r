#' Fetch open access status information and full-text links from oaDOI
#'
#' This is the main function to retrieve comprehensive open acccess status
#' information from the oaDOI service. Please play nice with the API. At the
#' moment only 10k request are allowed per user and day.
#' For more info see \url{http://oadoi.org/api}.
#'
#' @param dois character vector, search by a single DOI or many DOIs. The API is limited
#'   to 10,000 requests per day. If you need more, get in touch with
#'   team@impactstory.org.
#' @param email character verctor, tell oaDOI your email adress to get notified
#'   if something breaks. It also helps oaDOI to keep track of usage!
#' @param .progress Shows the \code{plyr}-style progress bar. Options are "none", "text",
#'   "tk", "win", and "time".  See \code{\link[plyr]{create_progress_bar}} for details
#'   of each. By default, no progress bar is displayed.
#'
#' @return A tibble
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
        "The rate limit is 10k requests per day.
        Get in touch with team@impactstory.org to get an upgrade.",
        .call = FALSE
      )
    plyr::ldply(dois, oadoi_api_, .progress = .progress) %>%
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
#' oadoi_api_(dois = c("10.1016/j.jbiotec.2010.07.030")
#' }
#' @export
oadoi_api_ <- function(doi = NULL, email = NULL) {
  u <- httr::modify_url(oadoi_baseurl(),
                        query = args_(email = email),
                        path = doi)
  resp <- httr::GET(u,
                    ua,
                    # be explicit about the API version roadoi has to request
                    add_headers(
                      Accept = paste0("application/x.oadoi.", oadoi_api_version(), "+json")
                    ))

  # test for valid json
  if (httr::http_type(resp) != "application/json") {
    # test needed because oaDOI throws 505 when non-encoded whitespace
    # is provided by this client
    stop(
      sprintf(
        "Oops, API did not return json after calling '%s': check your query - or api.oadoi.org may experience problems",
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
