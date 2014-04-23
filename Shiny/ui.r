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
        tabPanel("Data Explorer",
          dataTableOutput(outputId="table")
          #tableOutput("table")
        ), #tabPanel1
        
        tabPanel("Graphics",
          conditionalPanel()
          plotOutput("plot"),
          showOutput("plot2", "dimple")
        ) #tabPanel2
      ) #tabsetPanel
      
    ) #mainPanel
  
  
  )#sidebarlayout
))#shinyUI, fluidpage