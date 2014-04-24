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
      plot = healthstateplot
    }
    if(input$dataset == "Income") {
      plot = plot.income.male
    }
    if(input$dataset == "Jobs") {
      plot = empstateplot
    }
    if(input$dataset == "Poverty") {
      plot = povstateplot
    }
    if(input$dataset == "University") {
      plot = univprivplot
    }   
    print(plot) 
  }) #renderPlot plot

  output$plot2 <- renderPlot({
    if(input$dataset == "Income") {
      plot = plot.income.female
    }
    print(plot)
  }) #renderPlot plot2
  
  output$plot3 <- renderPlot({
    if(input$dataset == "Income") {
      plot = incomerank
    }
    print(plot)
  }) #renderPlot plot3 
  
  output$poverty1 <- renderChart2({
    return(povstateedu)
  }) #renderchart poverty1
  
  output$poverty2 <- renderChart2({
    return(povstateedutotal)
  }) #renderchart poverty2
  
  output$food1 <- renderChart2({
    return(foodstaterace)
  }) #renderchart food1
  
  output$food2 <- renderChart2({
    return(foodstateracetotal)
  }) #renderchart food2
  
  output$health1 <- renderChart2({
    return(privhealth.income)
  }) #renderchart food2
  
  output$jobs1 <- renderChart2({
    return(state.age.unemployed)
  }) #renderchart food2
  
  output$jobs2 <- renderChart2({
    return(type.age)
  }) #renderchart food2
  
  
}) #shinyserver