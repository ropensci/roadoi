globalVariables(c("is_valid", "."))

oadoi_baseurl <- function() "http://api.oadoi.org/"
oadoi_api_version <- function() "v1"


# Validation used in Lagotto software: The prefix is 10.x where x is 4-5 digits.
# The suffix can be anything, but can't be left off
doi_validate <- function(doi = NULL) {
  is_valid <- grepl(pattern = "(^10\\.\\d{4,5}/.+)", doi)
  cbind(is_valid, doi)
}
