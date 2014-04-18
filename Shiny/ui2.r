library(shiny)
shinyUI(fluidPage(
  
  #title
  titlePanel("EasieR Stats"),
  
  #main
  sidebarLayout(  
    
    sidebarPanel(
      selectInput("stateVariable", "State",
                  c("All", "Texas", "Utah")            
      ),    
      
      conditionalPanel(condition = "input.selectCategory=='Age'",
        selectInput("ageVariable", "States",
          c("Blah", "test")
        )
      ),
      
      conditionalPanel(condition = "input.selectCategory=='Food Stamps'",
        selectInput("foodVariable", "Race",
          c("Total", "Asian", "Black", "Latino", "Indian/Pacific Islander", "White", "Other")            
        )
      ),
      
      conditionalPanel(condition = "input.selectCategory=='Healthcare'",
        selectInput("healthVariable", "Healthcare Variables",
          c("Total", "By Age", "By Income")            
        )
      ),
      
      conditionalPanel(condition = "input.selectCategory=='Income'",
        selectInput("genderVariable", "Gender",
          c("Male", "Female")      
        ),
        selectInput("incomeVariable", "Full/Part",
          c("Full-time", "Part-time")           
        )
      ),
      
      conditionalPanel(condition = "input.selectCategory=='Jobs'",
        selectInput("jobsVariable", "Job Variables",
          c("Total", "By Age", "By Gender")            
        )
      ),
      
      conditionalPanel(condition = "input.selectCategory=='Poverty'",
        selectInput("povertyVariable", "Poverty Variables",
          c("Total", "By Type", "By Education")            
        )
      ),
      
      conditionalPanel(condition = "input.selectCategory=='University'",
        selectInput("univVariable", "University Variables",
          c("Total", "By Gender", "By Age Group")            
        )
      )
      
      
    #//sidebarPanel  
    ),
    
    mainPanel(
      tabsetPanel(id="selectCategory",
        tabPanel("Age"),
        tabPanel("Food Stamps"),
        tabPanel("Healthcare"),
        tabPanel("Income"),
        tabPanel("Jobs"),
        tabPanel("Poverty"),
        tabPanel("University")
      )
    
    #//mainPanel
    )
    
  #//sidebarLayout
  )
))

