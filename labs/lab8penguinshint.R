library(palmerpenguins)
data("penguins")
library(tidyverse)
library(tidymodels)
library(openintro)
library(mdsr)
library(mosaicData)
library(shiny)
library(dplyr)
library(ggplot2)

# User interface
ui <- fluidPage(
  titlePanel("Let's Measure Some Penguins!"),
  sidebarLayout(
    sidebarPanel(
      # Text input widget for penguin species
      selectizeInput(inputId = "species",
                     label = "Enter Penguin Species Here",
                     choices = NULL,
                     multiple = TRUE),
      
      p("Put single space between the species."),
      
      # Button input widgets for measurement attributes
      #x variable
      radioButtons("x_var",
                   label = "Select X Variable:",
                   choiceNames = list("Bill Length", "Bill Depth", "Flipper Length", "Body Mass"),
                   choiceValues = list("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g"),
                   selected = c("bill_length_mm"),
                   inline = TRUE),
      #y variable
      radioButtons("y_var",
                   label = "Select Y Variable:",
                   choiceNames = list("Bill Length", "Bill Depth", "Flipper Length", "Body Mass"),
                   choiceValues = list("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g"),
                   selected = c("bill_depth_mm"),
                   inline = TRUE),
      
      submitButton("Update Results!")
    ),
    
    mainPanel(
      plotOutput(outputId = "graph")
    )
  )
)

server <- function(input, output, session){
  
  updateSelectizeInput(session, 'species', 
                       choices = unique(penguins$species), 
                       server = TRUE)
  
  dat_penguins <- reactive({ 
    penguins %>%
      filter(species %in% c(unlist(str_split(input$species, " "))))

  })
  
  output$graph <- renderPlot({
    
    ggplot(data = dat_penguins(), aes(x = input$x_var, y = input$y_var, color = input$species)) +
      geom_point()
  })
  
}

# Creates app
shinyApp(ui = ui, server = server)