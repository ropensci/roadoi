globalVariables(c("is_valid", "."))

oadoi_baseurl <- function() "http://api.oadoi.org/"
oadoi_api_version <- function() "1.1.0"
api_limit <- 10000

# user agent, so that oaDOI can track the usage of this client
ua <- httr::user_agent("https://github.com/njahn82/roadoi")

# Validation used in Lagotto software: The prefix is 10.x where x is 4-5 digits.
# The suffix can be anything, but can't be left off
doi_validate <- function(doi = NULL) {
  is_valid <- grepl(pattern = "(^10\\.\\d{4,5}/.+)", doi)
  cbind(is_valid, doi)
}

# helper to prepare query path for http requests
args_ <- function(email = NULL) {
  if(is.null(email))
    NULL
  else
  list(email = email)
}
