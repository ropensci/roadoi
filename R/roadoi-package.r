#' R Client for the oaDOI-API
#'
#' @section What is this client for?:
#' roadoi interacts with the oaDOI service, which links DOIs that are often used
#' to identify scholarly works with open access versions.
#'
#' @section General usage:
#' Use the \code{oadoi_fetch()} function in this package to get open access status
#' information and full-text links from oaDOI. Please note that oaDOI restricts
#' usage to 10k requests per day.
#'
#' @section Participate:
#' I would be very happy for people willing to contribute to this package.
#' It is important to keep in mind that oaDOI is still in early development,
#' which could affect the API and this client.
#'
#' @import httr
#' @importFrom jsonlite fromJSON
#' @import dplyr
#' @importFrom plyr ldply
#' @import tibble
#' @name roadoi-package
#' @aliases roadoi
#' @docType package
#' @keywords package
NULL
