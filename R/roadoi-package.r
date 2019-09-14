#' R Client for the Unpaywall-API
#'
#' @section What is this client for?:
#' roadoi interacts with the Unpaywall data service, which links DOIs representing
#' scholarly works with open access versions.
#'
#' @section General usage:
#' Use the \code{oadoi_fetch()} function in this package to get open access status
#' information and full-text links from Unpaywall
#'
#' @section Contribute:
#' You are welcome to contribute to this package. Use
#' GitHubs issue tracker for bug reporting and feature requests.
#'
#' @importFrom httr GET content modify_url user_agent add_headers status_code timeout RETRY http_type
#' @importFrom jsonlite fromJSON
#' @importFrom plyr ldply create_progress_bar llply
#' @importFrom dplyr %>% select mutate bind_rows
#' @importFrom miniUI miniContentPanel gadgetTitleBar miniPage
#' @importFrom shiny dialogViewer runGadget renderTable reactive observeEvent tableOutput actionButton textAreaInput tags stopApp
#' @importFrom purrr map map_if compact
#' @importFrom tibble tibble as_tibble
#' @importFrom tidyr unnest
#' @name roadoi-package
#' @aliases roadoi
#' @docType package
#' @keywords package
NULL
