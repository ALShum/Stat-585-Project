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
           "AgeGender" = agesextable,
           "Foodstamps" = foodtable,
           "Health" = healthincometable,
           "Income" = medincometable,
           "Jobs" = emptable,
           "Poverty" = povtable,
           "University" = univtable)
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
      plot = stampstateplot
    }
    if(input$dataset == "Health") {
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
      plot = povstateplot
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
  
  output$plot_income <-  renderPlot({
    plot = plot.income.female
    print(plot)
  })
  
  
}) #shinyserver