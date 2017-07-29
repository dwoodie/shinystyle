library(shiny)
library(DT)

mynavbar <- readLines('www/navbar.txt')
myheader <- readLines('www/header.txt')
introduction <- readLines('www/introduction.txt')
thesurvey <- readLines('www/thesurvey.txt')
thedata <- readLines('www/thedata.txt')
conclusion <- readLines('www/conclusion.txt')
# Define UI for application that draws a histogram
shinyUI(
  fluidPage(theme="mystyle.css",
            
    tags$head(
      tags$link(rel="stylesheet", type = "text/css", href = "https://fonts.googleapis.com/css?family=Merriweather|Roboto")
    ),
    
    HTML(mynavbar),
    HTML(myheader),
    HTML(introduction),
    HTML(thesurvey),
    HTML(thedata),
    # Create a div to center the tool
    div(class="container-fluid", 
        div(id="myContent",
      # Show a plot of the generated distribution
      # mainPanel(class="col-sm-12", id="myContent",
        fluidRow(
          column(3, 
        selectInput("experience", 
                    "Experience:",
                    choices = c("All", "0-1", "2-3", "4-5", ">5"),
                    selected = "All")
        ),
        column(3, 
        selectInput("workshop",
                    "Workshop:",
                    choices = c("Both" , "Lightning Talk", "Monthly"),
                    selected = "Both")
        ),
        column(3, 
        selectInput("funding", 
                    "Funding:",
                    choices = c("Both", "Donation", "Low Fee"),
                    selected = "Both")
        ),
        column(3, 
               selectInput("topic", 
                           "Interests:",
                           choices = c("All", 
                                       "R/RStudio", 
                                       "Linear Modeling",
                                       "Data Visualization",
                                       "Neural Networks",
                                       "Data Transformations",
                                       "Data Reporting",
                                       "Dashboards",
                                       "Spark",
                                       "Machine Learning",
                                       "Databases",
                                       "Graphical Models",
                                       "git"),
                           selected = "All")
        )
        ),
        fluidRow(height = "200",
          column(4, plotOutput('experience_plot', height="200px")),
          column(4, plotOutput('workshop_plot', height="200px")),
          column(4, plotOutput('funding_plot', height="200px"))
        ),
        fluidRow(
          column(12, plotOutput('interest_plot', height='250px'))
        )
        ) # Closes the id div
    ), # Closes the class div
    HTML(conclusion)
    
))
