library(shiny)

shinyUI(fluidPage(
  
  #title
  titlePanel("EasieR Stats"),
  
  #main
  sidebarLayout(
    
    
    sidebarPanel(
      conditionalPanel(condition = "input.selectCategory=='Economic'",
        selectInput("econVariable", "Economic Variables",
          c("Median Income", "Poverty Status", "Food Stamp", "Employment")
        )
      ),
      
      conditionalPanel(condition = "input.selectCategory=='Housing'",
        selectInput("houseVariable", "Housing Variables",
          c("Median Rent", "Occupancy Rates")            
        )
      ),
      
      conditionalPanel(condition = "input.selectCategory=='People'",
        selectInput("peopleVariable", "Demographic Variables",
          c("Age")            
        )
      ),
      
      conditionalPanel(condition = "input.selectCategory=='Education'",
        selectInput("eduVariable", "Education Variables",
          c("Education Attainment")      
        )
      ),
      
      conditionalPanel(condition = "input.selectCategory=='Healthcare'",
        selectInput("healthVariable", "Healthcare Variables",
          c("Healthcare Coverage")            
        )
      )
      
    #//sidebarPanel  
    ),
    
    mainPanel(
      tabsetPanel(id="selectCategory",
        tabPanel("Economic"),
        tabPanel("Housing"),
        tabPanel("People"),
        tabPanel("Education"),
        tabPanel("Healthcare")
      )
    
    #//mainPanel
    )
    
  #//sidebarLayout
  )
))

