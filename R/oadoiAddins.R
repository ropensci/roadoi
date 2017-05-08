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
roadoi_addin <- function() { # nocov start
  # create user interface like the one rcrossref provides
  ui <- miniPage(
    gadgetTitleBar("Find freely available full-text via oaDOI.org"),
    miniContentPanel(
      tags$h4("Find fulltexts for scholarly articles"),
      tags$p(
        "If you have DOIs (Digital Object Identifier) for several articles and would like to find freely available copies, simply paste your DOIs in the text box below. Please note that only the first ten DOIs will be fetched."
      ),
      textAreaInput(
        inputId = "text",
        label = "DOIs (line separated):",
        value = "10.1007/s13752-012-0049-z\n10.1098/rsta.2016.0122",
        height = 200
      ),
      actionButton(inputId = "submit", "Run!"),
      tableOutput("table")
    )
  )
  # here's the server-side R code that will be executed to find OA copies
  server <- function(input, output) {
    observeEvent(input$submit, {
      my_input <- reactive({
        # avoid warnings about "no visible binding for global variable"
        `Free fulltext link` <- NULL
        `_best_open_url` <- NULL
        doi <- NULL
        dois <- unlist(strsplit(input$text, "\n"))
        # limit input to 10
        if (length(dois) > 9)
          dois <- dois[1:10]
        # prepare API call
        email <- ifelse(!is.null(getOption("roadoi_email")),
                        getOption("roadoi_email"),
                        "name@example.com")
        # fetch full-text links and return the best match
        roadoi::oadoi_fetch(dois, email) %>%
          select(`Free fulltext link` = `_best_open_url`, doi) %>%
          mutate(`Free fulltext link` = ifelse(
            is.na(`Free fulltext link`),
            NA,
            create_link(`Free fulltext link`)
          ))
      })
      # output as table
      output$table <- renderTable(
        my_input(),
        sanitize.text.function = function(x)
          x
      )
    })
  }

  # finally, define where and how the gadget is displayed
  viewer <- dialogViewer("Find free full-texts",
                         width = 800, height = 800)
  runGadget(ui, server, viewer = viewer)
}

# helper to make links clickable
create_link <- function(x) {
  paste0('<a href="', x, '" target="_blank">', x, '</a>')
}

# nocov end
