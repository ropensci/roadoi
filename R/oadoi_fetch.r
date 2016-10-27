#' Fetch open access status information and full-text links from oaDOI
#'
#' This is the main function to retrieve comprehensive open acccess status
#' information from the oaDOI service. Please play nice with the API. At the
#' moment only 10k request are allowed per user and day.
#' More info see \url{http://oadoi.org/api}
#'
#' @param dois character vector, search by a single DOI or many DOIs.
#'
#' @examples \dontrun{
#' oadoi_fetch(dois = c("10.1016/j.jbiotec.2010.07.030",
#' "10.1186/1471-2164-11-245"))
#' }
#'
#' @export
oadoi_fetch <- function(dois = NULL) {
  # validate dois
  dois <- plyr::ldply(dois, doi_validate)
  if (nrow(dois[dois$is_valid == FALSE,]) > 0)
    warning("Found mal-formed DOIs, which will not be send to oaDOI")
  dois <- dplyr::filter(dois, is_valid == TRUE) %>%
    .$doi %>%
    as.character()
  if (length(dois) > 25) {
    # loop
    out <- data.frame()
    for(i in seq(1, length(dois), by = 25)) {
      tt <- dois[i:(i+24)]
      tt <- tt[!is.na(tt)]
      out_tmp <- oadoi_api_(tt)
      out <- dplyr::bind_rows(out, out_tmp)
      out
    }
  } else {
    out <- oadoi_api_(dois)
  }
  return(tibble::as_data_frame(out))
}

#' Post one request to access open access status information.
#'
#' In general, use oadoi_fetch instead. It calls this method, returning open
#' access status information from all your requests. One request comprises up to
#' 25 DOIs at a time.
#'
#' @param dois character vector with dois
#' @return A tibble
#' @examples \dontrun{
#' oadoi_api_(dois = c("10.1016/j.jbiotec.2010.07.030",
#' "10.1186/1471-2164-11-245"))
#' }
#' @export
oadoi_api_ <- function(dois = NULL) {
  if(length(dois) == 1) {
    u <- httr::modify_url(oadoi_baseurl(),
                          path = c(oadoi_api_version(), "publication", "doi", dois))
    resp <- httr::GET(u)
  } else {
    u <- httr::modify_url(oadoi_baseurl(),
                          path = c(oadoi_api_version(), "publications"))
    resp <- httr::POST(url = u,
                       body = list(dois = dois),
                       encode = "json", httr::accept_json(), httr::content_type_json())
  }
  # parse json
  if (httr::http_type(resp) != "application/json") {
    stop("Ups, something went wrong, because API did not return json", call. = FALSE)
  }
  jsonlite::fromJSON(content(resp, "text", encoding = "UTF-8"))$results %>%
    tibble::as_data_frame()
}
