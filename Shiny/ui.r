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
          plotOutput("plot"),
          conditionalPanel(condition="input.dataset=='Poverty'",
                           showOutput("poverty1", "dimple"),
                           showOutput('poverty2', 'dimple')),
          conditionalPanel(condition="input.dataset=='Foodstamps'",
                           showOutput("food1", "dimple"),
                           showOutput('food2', 'dimple')),
          conditionalPanel(condition="input.dataset=='Health'",
                           showOutput("health1", "dimple")),
          conditionalPanel(condition="input.dataset=='Jobs'",
                           showOutput("jobs1", "dimple"),
                           showOutput('jobs2', 'dimple')),
          conditionalPanel(condition="input.dataset=='Income'",
                           plotOutput("plot2")),
          conditionalPanel(condition="input.dataset=='Income",
                           plotOutput("plot3"))

        ) #tabPanel2
      ) #tabsetPanel
      
    ) #mainPanel
  
  
  )#sidebarlayout
))#shinyUI, fluidpage