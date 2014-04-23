library(shiny)
library(rCharts)
source("../Plots/ageplots.R")
source("../Plots/foodstampsplots.R")
source("../Plots/healthplots.R")
source("../Plots/incomeplots.R")
source("../Plots/jobsplots.R")
source("../Plots/povertyplots.R")
source("../Plots/universityplots.R")

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
  
  output$table <- renderDataTable({
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
  
  output$plot <- renderPlot({
    if(input$dataset == "AgeGender") {
      plot = pop.py
    }
    if(input$dataset == "Foodstamps") {
      plot = qplot(rgamma(100,10,5))
    }
    if(input$dataset == "Health") {
      p = dPlot(x = "state", y = "freq", groups = "age", data = healthsex, type = "bar")
      p$xAxis(orderRule = "state")
      p$yAxis(type = "addPctAxis")
      plot = p
      plot = NULL
    }
    if(input$dataset == "Income") {
      # Plot median income (male)
      plot = plot.income.male
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
  }) #renderPlot

  output$plot2 <- renderChart2({
    p = dPlot(x = "state", y = "freq", groups = "age", data = healthsex, type = "bar")
    p$xAxis(orderRule = "state")
    p$yAxis(type = "addPctAxis")
    return(p)
  })
  
  
}) #shinyserver