roadoi_addin <- function() {
  # create user interface like the one rcrossref provides
  ui <- miniPage(
    gadgetTitleBar("Find freely available full-text via oaDOI.org"),
    miniContentPanel(
      tags$h4("Find fulltexts for scholarly articles"),
      p(
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

  server <- function(input, output) {
    observeEvent(input$submit, {
      my_input <- reactive({
        dois <- unlist(strsplit(input$text, "\n"))
        if(length(dois) > 9)
          dois <- dois[1:10]
        roadoi::oadoi_fetch(dois) %>%
          select(`Free fulltext link` = `_best_open_url`, doi) %>%
          mutate(`Free fulltext link` = ifelse(
            is.na(`Free fulltext link`),
            NA,
            create_link(`Free fulltext link`)
          ))
      })
      output$table <- renderTable(
        my_input(),
        sanitize.text.function = function(x)
          x
      )
    })
  }

  # We'll use a pane viewer, and set the minimum height at
  # 300px to ensure we get enough screen space to display the clock.
  viewer <- dialogViewer("Find free fulltexts", width = 800, height = 800)
  runGadget(ui, server, viewer = viewer)

}

# Now all that's left is sharing this addin -- put this function
# in an R package, provide the registration metadata at
# 'inst/rstudio/addins.dcf', and you're ready to go!

create_link <- function(x) {
  paste0('<a href="', x, '" target="_blank">', x, '</a>')
}
