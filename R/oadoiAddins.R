#' Find OA copies with RStudio addin
#'
#' An \href{https://rstudio.github.io/rstudioaddins/}{RStudio addin} to call
#' \code{oadoi_fetch()}. Shows up as "Find free full-texts" in the RStudio addin
#' menu.
#'
#' The addin works as follows:
#'
#' \enumerate{
#'
#' \item Copy up to ten line-separated DOIs into the text area
#' \item Press the button "Run!"
#' \item Click on the links in the table to download full-text
#' }
#'
#' @export
roadoi_addin <- function() {
  # nocov start
  # create user interface like the one rcrossref provides
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Find freely available full-text via Unpaywall"),
    miniUI::miniContentPanel(
      shiny::tags$h4("Find fulltexts for scholarly articles"),
      shiny::tags$p(
        "If you have DOIs (Digital Object Identifier) for several articles
        and would like to find freely available copies, simply paste your DOIs
        in the text box below. Please note that only the first ten DOIs will
        be fetched."
      ),
      shiny::textAreaInput(
        inputId = "email",
        label = "Please add your email address",
        value = ifelse(!is.null(getOption("roadoi_email")),
                       getOption("roadoi_email"),
                       "Enter your email ...")
      ),
      shiny::textAreaInput(
        inputId = "text",
        label = "DOIs (line separated):",
        value = "10.1007/s13752-012-0049-z\n10.1098/rsta.2016.0122",
        height = 200
      ),
      shiny::actionButton(inputId = "submit", "Run!"),
      shiny::tableOutput("table"),
      shiny::tags$hr(),
      shiny::tags$p(
        "Free full-text links from Unpaywall",
        shiny::tags$a(
          shiny::tags$img(
            src = "https://raw.githubusercontent.com/Impactstory/unpaywall/master/static/img/icon-128.png"
            ),
          href = "https://unpaywall.org/"
        ),
        align = "right"
      )
      )
  )
  # here's the server-side R code that will be executed to find OA copies
  server <- function(input, output) {
    shiny::observeEvent(input$submit, {
      my_input <- reactive({
        # avoid warnings about "no visible binding for global variable"
        `Free fulltext link` <- NULL
        `best_oa_location` <- NULL
        doi <- NULL
        dois <- unlist(strsplit(input$text, "\n"))
        dois <- dois[dois != ""]
        # limit input to 10
        if (length(dois) > 9)
          dois <- dois[1:10]
        # prepare API call
        # fetch full-text links and return the best match
        tt <- roadoi::oadoi_fetch(dois, input$email)
        if (any(tt$is_oa)) {
          tt %>%
            tidyr::unnest(best_oa_location) %>%
            dplyr::select(`Free fulltext link` = url, doi) %>%
            dplyr::mutate(`Free fulltext link` = ifelse(
              is.na(`Free fulltext link`),
              NA,
              create_link(`Free fulltext link`)
            ))
        } else {
          data.frame(`Free fulltext link` = "Sorry, nothing found")
        }
      })
      # output as table
      output$table <- shiny::renderTable(
        my_input(),
        sanitize.text.function = function(x)
          x
      )
    })
    # finish interacting with addin when 'done' is clicked
    shiny::observeEvent(input$done, {
      shiny::stopApp()
    })
  }

  # finally, define where and how the gadget is displayed
  viewer <- shiny::dialogViewer("Find free full-texts",
                                width = 800, height = 800)
  shiny::runGadget(ui, server, viewer = viewer)
}

# helper to make links clickable
# nolint start
create_link <- function(x) {
  paste0('<a href="', x, '" target="_blank">', x, '</a>')
}
# nolint end

# nocov end
