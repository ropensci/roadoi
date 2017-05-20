# meta
oadoi_baseurl <- function()
  "https://api.oadoi.org/"
# API version
oadoi_api_version <- function()
  "1.3.0"
# If you require access to more data, please use the data dump
api_limit <- 100000

# user agent, so oaDOI can track the usage of this client
ua <- httr::user_agent("https://github.com/njahn82/roadoi")

#' Email checker for roadoi API
#'
#' It implementents the following regex stackoverflow solution
#' http://stackoverflow.com/a/25077140
#'
#' @param email email address (character string)
#'
#' @noRd
val_email <- function(email) {
  if (is.null(email) && !is.character(email))
    stop("An email address is required to use oaDOI API", call. = FALSE)
  if (!grepl(email_regex(), email))
    stop("Email address seems not properly formatted - Please check!",
         call. = FALSE)
  return(email)
}

#' Email regex
#'
#' From \url{http://stackoverflow.com/a/25077140}
#'
#' @noRd
email_regex <-
  function()
    "^[_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,4})$"
