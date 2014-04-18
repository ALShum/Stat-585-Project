library(shiny)
library(acs)

shinyServer(function(input, output, session) {
  
  
  output$mpgPlot <- renderPlot({
    boxplot(as.formula(formulaText()), 
            data = mpgData,
            outline = input$outliers)
  })
  
  
})