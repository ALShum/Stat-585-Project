library(shiny)
shinyUI(fluidPage(
  titlePanel('EasieR Stats'),
  sidebarLayout(
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
    ),
    mainPanel(
      tableOutput('table')
    )
  )
))