# meta
oadoi_baseurl <- function() "http://api.oadoi.org/"
oadoi_api_version <- function() "1.1.0"
api_limit <- 10000

# user agent, so oaDOI can track the usage of this client
ua <- httr::user_agent("https://github.com/njahn82/roadoi")

# helper to prepare query path for http requests
args_ <- function(email = NULL) {
  if(is.null(email))
    NULL
  else
  list(email = email)
}
