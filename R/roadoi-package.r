#' R Client for the oaDOI-API
#'
#' @section What is this client for?:
#' roadoi interacts with the oaDOI data service, which links DOIs representing
#' scholarly works with open access versions.
#'
#' @section General usage:
#' Use the \code{oadoi_fetch()} function in this package to get open access status
#' information and full-text links from oaDOI.
#'
#' @section Contribute:
#' I would be very happy for people willing to contribute to this package.
#' It is important to keep in mind that oaDOI is still in early development,
#' which could affect the API and this client.
#'
#' @importFrom httr GET content modify_url user_agent add_headers status_code timeout
#' @importFrom jsonlite fromJSON
#' @importFrom plyr ldply create_progress_bar
#' @importFrom dplyr as_data_frame %>% select mutate
#' @importFrom miniUI miniContentPanel gadgetTitleBar miniPage
#' @importFrom shiny dialogViewer runGadget renderTable reactive observeEvent tableOutput actionButton textAreaInput tags stopApp
#' @importFrom purrr map map_if compact
#' @importFrom tibble tibble
#' @name roadoi-package
#' @aliases roadoi
#' @docType package
#' @keywords package
NULL
