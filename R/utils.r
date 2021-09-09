# meta
oadoi_baseurl <- function()
  "https://api.unpaywall.org/"
# API version
oadoi_api_version <- function()
  "v2"
# If you require access to more data, please use the data dump
api_limit <- 100000

# user agent, so Unpaywall can track the usage of this client
ua <- httr::user_agent("https://github.com/ropensci/roadoi")

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
    stop("An email address is required to use Unpaywall API", call. = FALSE)
  if (!grepl(email_regex(), email))
    stop("Email address seems not properly formatted - Please check!",
         call. = FALSE)
  if (grepl("example.com", email))
    stop("Unpaywall Data does not allow usage of 'example.com' email addresses")
  return(email)
}

#' Email regex
#'
#' From \url{http://stackoverflow.com/a/25077140}
#'
#' @noRd
email_regex <-
  function()
    # nolint start
    "^[_a-zA-Z0-9-]+(\\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*(\\.[a-zA-Z]{2,4})$"
    # nolint end

#' White space check
#'
#' @noRd
check_wsp_dois <- function(x) {
  wsp_doi <- x[grepl("[[:space:]]", x)]
  if (length(wsp_doi != 0))
    message(
      paste("Removed white space character(s) from:", wsp_doi))
    }
