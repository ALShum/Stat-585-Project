library(shiny)
shinyUI(fluidPage(
  titlePanel('EasieR Stats'),
  sidebarLayout(

  conditionalPanel(condition = "input.selectCategory=='Summary/Download'",    
    sidebarPanel(
      helpText("Data explorer for 2012 American Community Survey
                5-year dataset"),
      selectInput("dataset", "Choose a dataset:", 
                  choices = c("Age/Gender", "Foodstamps",
                              "Health", "Income",
                              "Jobs", "Poverty",
                              "University")),
      radioButtons("filetype", "File type:",
                    choices = c("csv", "tsv")),
      downloadButton('downloadData', 'Download')  
    ) #sidebarPanel
  ), #conditionalPanel


    mainPanel(
      tabsetPanel(id="selectCategory",
        tabPanel("Summary/Download"),
        tabPanel("Data Explorer")
      ), #tabsetPanel
      
      conditionalPanel(condition = "input.selectCategory=='Summary/Download'",
        tableOutput('table')
      ), #conditionalPanel

      conditionalPanel(condition = "input.selectCategory=='Data Explorer'",
        helpText("placeholder for datatableoutput")
      ) #conditionalPanel
    ) #mainPanel
  
  
  )#sidebarlayout
))#shinyUI, fluidpage