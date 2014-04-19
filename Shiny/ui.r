library(shiny)
shinyUI(fluidPage(
  titlePanel('EasieR Stats'),
  sidebarLayout(

  
  sidebarPanel(
    helpText("Data explorer for 2012 American Community Survey
              5-year dataset"),
    selectInput("dataset", "Choose a dataset:", 
                choices = c("AgeGender", "Foodstamps",
                            "Health", "Income",
                            "Jobs", "Poverty",
                            "University")),
    radioButtons("filetype", "File type:",
                  choices = c("csv", "tsv")),
    downloadButton('downloadData', 'Download')  
  ), #sidebarPanel

    mainPanel(
      tabsetPanel(id="selectCategory",
        tabPanel("Data Explorer"),
        tabPanel("Graphics")
      ), #tabsetPanel
      
      conditionalPanel(condition = "input.selectCategory=='Data Explorer'",
        tableOutput('table')
      ), #conditionalPanel1

      conditionalPanel(condition = "input.selectCategory=='Graphics'",
        helpText("placeholder for datatableoutput"),
        #dataTableOutput(outputId='table')
        plotOutput("plot")  
      ) #conditionalPanel2
    ) #mainPanel
  
  
  )#sidebarlayout
))#shinyUI, fluidpage