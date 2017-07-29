library(shiny)
library(DT)
library(dplyr)
library(ggplot2)
library(tidyr)

survey <- read.csv("data/survey.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  survey_data <- reactive({
    
    survey_temp <- survey
    
    if (input$experience != "All") {
      survey_temp <- survey_temp %>% filter(Years == input$experience)
    }
    
    if (input$workshop != "Both") {
      survey_temp <- survey_temp %>% filter(Workshop == input$workshop)
    }
    
    if (input$funding != "Both") {
      survey_temp <- survey_temp %>% filter(Fund == input$funding)
    }
    
    if (input$topic != "All") {
      survey_temp <- survey_temp %>% filter(grepl(input$topic, Interests))
    }
    
    # Set the order for the factors
    if (any(is.na(survey_temp$Years))) {
      survey_temp$Years <- factor(survey_temp$Years, levels=c("0-1", "2-3", "4-5", ">5"))
    } else {
      survey_temp$Years <- factor(survey_temp$Years, levels=c("0-1", "2-3", "4-5", ">5", "NA"))
    }
    
    if (any(is.na(survey_temp$Workshop))) {
      survey_temp$Workshop <- factor(survey_temp$Workshop, levels=c("Monthly", "Lightning Talk"))
    } else {
      survey_temp$Workshop <- factor(survey_temp$Workshop, levels=c("Monthly", "Lightning Talk", "NA"))
    }
    
    if (any(is.na(survey_temp$Fund))) {
      survey_temp$Fund <- factor(survey_temp$Fund, levels=c("Low Fee", "Donation"))
    } else {
      survey_temp$Fund <- factor(survey_temp$Fund, levels=c("Low Fee", "Donation", "NA"))
    }
    
    
    survey_temp
  })
  
  output$tbl = DT::renderDataTable(
    survey_data(), options = list(lengthChange = FALSE)
  )
  
  output$experience_plot <- renderPlot({
    p <- ggplot(survey_data(), aes(Years)) + 
      geom_bar(colour="#0a2040", fill="#0a2040") +
      ggtitle(expression(underline("Years Experience"))) +
      scale_y_continuous(limits = c(0, 30), expand=c(0,0)) +
      scale_x_discrete(drop=FALSE) +
      theme(panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(),
            panel.background = element_blank(), 
            axis.line = element_line(colour = "black"),
            axis.ticks=element_blank(),
            axis.title.x=element_blank())
    print(p)
  })
  
  output$workshop_plot <- renderPlot({
    p <- ggplot(survey_data(), aes(Workshop)) + 
      ggtitle(expression(underline("Workshop Preference"))) +
      geom_bar(colour="#0a2040", fill="#0a2040") +
      scale_y_continuous(limits = c(0, 30), expand=c(0,0)) +
      scale_x_discrete(drop=FALSE) +
      theme(panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(),
            panel.background = element_blank(), 
            axis.line.x = element_line(colour = "black"),
            axis.text.y=element_blank(),
            axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank())
    print(p)
  })
    
  output$funding_plot <- renderPlot({
    p <- ggplot(survey_data(), aes(Fund)) + 
      geom_bar(colour="#0a2040", fill="#0a2040") +
      ggtitle(expression(underline("Funding Source"))) +
      scale_y_continuous(limits = c(0, 30), expand=c(0,0)) +
      scale_x_discrete(drop=FALSE) +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank(), 
            axis.line.x = element_line(colour = "black"),
            axis.text.y=element_blank(),
            axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank())
    print(p)
  })
  
  output$interest_plot <- renderPlot({
    
    interest_temp <- survey_data() %>% separate_rows(Interests, sep = ", ")
    interest_temp$Interests <- factor(interest_temp$Interests, 
                                      levels=c("Data Visualization", "Neural Networks",
                                               "Data Reporting", "Dashboards",
                                               "Databases", "Machine Learning", 
                                               "Spark", "Data Transformations",
                                               "Linear Modeling", "git", 
                                               "Graphical Models", "R/RStudio")) 
    interest_temp <- interest_temp[!is.na(interest_temp$Interests),]

    p <- ggplot(interest_temp, aes(Interests)) + 
      geom_bar(colour="#0a2040", fill="#0a2040") +
      ggtitle(expression(underline("Interests"))) +
      scale_y_continuous(limits = c(0, 30), expand=c(0,0)) +
      scale_x_discrete(drop=FALSE) +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank(), axis.line = element_line(colour = "black"),
            axis.text.x = element_text(angle = 90, hjust = 1),
            axis.title.x = element_blank())
    print(p)
    
  })
  
})
