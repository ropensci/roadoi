#' Fetch open access status information and full-text links from oaDOI
#'
#' This is the main function to retrieve comprehensive open acccess status
#' information from the oaDOI service. Please play nice with the API. At the
#' moment only 10k request are allowed per user and day.
#' For more info see \url{http://oadoi.org/api}
#'
#' @param dois character vector, search by a single DOI or many DOIs. A maximum
#'   of 10,000 DOIs are allowed per request.
#' @param email character verctor, tell oaDOI your email adress and get notified
#'   if something breaks. It also helps oaDOI to keep track of usage!
#' @param .progress Shows the \code{plyr}-style progress bar. Options are "none", "text",
#' "tk", "win", and "time".  See \code{\link[plyr]{create_progress_bar}} for details
#'  of each. By default, no progress bar is displayed.
#'
#' @return A tibble
#'
#' @examples \dontrun{
#' oadoi_fetch(dois = c("10.1016/j.jbiotec.2010.07.030",
#' "10.1186/1471-2164-11-245"))
#' }
#'
#' @export
oadoi_fetch <- function(dois = NULL, email = NULL, .progress = "none") {
  # limit
  if (length(dois) > api_limit)
    stop("The rate limit is 10k requests per day.
         Get in touch with team@impactstory.org to get an upgrade.", .call = FALSE)
  # validate dois
  dois <- plyr::ldply(dois, doi_validate)
  if (nrow(dois[dois$is_valid == FALSE,]) > 0)
    warning("Found mal-formed DOIs, which will not be send to oaDOI")
  dois <- dplyr::filter(dois, is_valid == TRUE) %>%
    .$doi %>%
    as.character()
  plyr::ldply(dois, oadoi_api_, .progress = .progress) %>%
    # wrap as tibble
    dplyr::as_data_frame()
}

#' Post one DOI to access open access status information.
#'
#' In general, use oadoi_fetch instead. It calls this method, returning open
#' access status information from all your requests.
#'
#' @inheritParams oadoi_fetch
#' @return A tibble
#' @examples \dontrun{
#' oadoi_api_(dois = c("10.1016/j.jbiotec.2010.07.030")
#' }
#' @export
oadoi_api_ <- function(dois = NULL, email = NULL) {
  u <- httr::modify_url(oadoi_baseurl(),
                        query = args_(email = email),
                        path = dois)
  resp <- httr::GET(
    u,
    ua,
    # be explicit about the API version roadoi has to request
    add_headers(
      Accept = paste0("application/x.oadoi.", oadoi_api_version(), "+json")))

    # parse json
    if (httr::http_type(resp) != "application/json") {
      stop("Ups, something went wrong, because API did not return json",
           call. = FALSE)
    }
    jsonlite::fromJSON(content(resp, "text", encoding = "UTF-8"))$results
}
