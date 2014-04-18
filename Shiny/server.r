library(shiny)
source("../Data Sets/age.R")
source("../Data Sets/foodstamps.R")
source("../Data Sets/health.R")
source("../Data Sets/income.R")
source("../Data Sets/jobs.R")
source("../Data Sets/poverty.R")
source("../Data Sets/university.R")

shinyServer(function(input, output) {
  datasetInput <- reactive({
    # Fetch the appropriate data object, depending on the value
    # of input$dataset.
    switch(input$dataset,
           "Age/Gender" = head(agesextable,10),
           "Foodstamps" = head(foodtable,10),
           "Health" = head(foodtable,10),
           "Income" = head(foodtable,10),
           "Jobs" = head(foodtable,10),
           "Poverty" = head(foodtable,10),
           "University" = head(foodtable,10))
  })
  
  output$table <- renderTable({
    datasetInput()
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, input$filetype, sep = ".")
    },
    
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
      
      # Write to a file specified by the 'file' argument
      write.table(datasetInput(), file, sep = sep,
                  row.names = FALSE)
    }
  )
})