library(shiny)
#library(rCharts)
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
           "AgeGender" = head(agesextable,52),
           "Foodstamps" = head(foodtable,52),
           "Health" = head(healthincometable,52),
           "Income" = head(medincometable,52),
           "Jobs" = head(emptable,52),
           "Poverty" = head(povtable,52),
           "University" = head(univtable,52))
  }) #datasetInput
  
  output$table <- renderTable({
    datasetInput()
  }) #output - table
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, input$filetype, sep = ".")
    },
    
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
      
      # Write to a file specified by the 'file' argument
      write.table(datasetInput(), file, sep = sep,
                  row.names = FALSE)
    }) #download data
  
  output$plot <- renderPlot(function() {
    if(input$dataset == "AgeGender") {
      plot = ggplot(data = agesextable, aes(x = age, y = freq, fill=gender)) +
        coord_flip() + geom_bar(subset = .(gender=="Female"), stat="identity") +
        geom_bar(subset = .(gender=="Male"), stat="identity", aes(y=-freq))
    }
    if(input$dataset == "Foodstamps") {
      plot = qplot(rgamma(100,10,5))
    }
    if(input$dataset == "Health") {
      #p = dPlot(x = "state", y = "freq", groups = "age", data = healthsex, type = "bar")
      #p$xAxis(orderRule = "state")
      #p$yAxis(type = "addPctAxis")
      #plot = p
    }
    if(input$dataset == "Income") {
      plot = NULL
    }
    if(input$dataset == "Jobs") {
      plot = NULL
    }
    if(input$dataset == "Poverty") {
      plot = NULL
    }
    if(input$dataset == "University") {
      plot = NULL
    }   
    print(plot)
  }) #reactivePlot

}) #shinyserver