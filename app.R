library(shiny)
library(tidyverse)
library(bslib)

data <- read_csv("taylor_swift_song_streams.csv") %>% 
  mutate(across(c(Year, Streams), as.integer), Album = factor(Album), Title = fct_reorder(Title, Streams, .desc = TRUE)) 

ui <- fluidPage(
  # Set theme
  theme = bs_theme(version = 4, bootswatch = "cerulean"),
  
  # Title
  titlePanel("Taylor Swift: Folklore to Midnights Streaming Statistics"),

  # Layout
  sidebarLayout(
    # Sidebar Items
    sidebarPanel(
      # Feature 1: Option to filter for album of interest or selectively view songs that have been streamed x amount of times
      selectInput("albumFilter", "Choose an album", c("All", "Folklore", "Evermore", "Midnights")),
      sliderInput("streamFilter", "Filter by number of streams", min = 0, max = 300000000, value = c(0, 300000000), step = 500000)
    ),
    
    # MainPanel Items
    mainPanel(
      
      # Feature 2: Add images for respective albums. Useful as a easy, visual feature for the user to identify each album with
      # Divide images onto one line
      div(style="display:flex;",
          imageOutput("folklore_image", width = "25vw"),
          imageOutput("evermore_image", width = "25vw"),
          imageOutput("midnights_image", width = "25vw")
      ),
      
      # Feature 3: Add plots and table. Utility to the user to visually see highest streaming songs and identify the data behind it. 
      # Tabs for plot and table
      tabsetPanel(
        tabPanel("Plot",
                 plotOutput("song_streams")),
        tabPanel("Table",
                 DT::dataTableOutput("data_table"))
      )
    )
  )
)



server <- function(input, output) {
  
  # For feature 1
  # Filter data
    filtered_data <- 
      reactive({
        # If there is a filter applied to album, then apply filter, otherwise don't (but the written logic here is reversed)
        if (input$albumFilter == "All") {
          data %>% 
            filter(Streams > input$streamFilter[1] &
                   Streams < input$streamFilter[2])
          }
        else {
            data %>% 
              filter(Streams > input$streamFilter[1] &
                     Streams < input$streamFilter[2],
                     Album == input$albumFilter)
          }
      })
    
    # For feature 3
    # Output plot. Plot the output of the dynamic data
    output$song_streams <- renderPlot({
      filtered_data() %>% 
        ggplot(aes(x = Title, y = Streams)) +
        geom_col() +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        scale_y_continuous(breaks = seq(0, 300000000, by = 50000000)) +
        labs(x = "Songs", y = "Number of Streams")
      })
    
    # Output data table. Arrange table from most streams to least
    output$data_table <- DT::renderDataTable({
      filtered_data() %>% 
        arrange(desc(Streams))
      })
    
    # For feature 2
    # Output images. If album filter is applied, then only show that image
    output$folklore_image <- renderImage({
      if (input$albumFilter == "Folklore" | input$albumFilter == "All") {
        list(
          src = "images/folklore.png",
          contentType = "image/png"
        )} 
      else {
        list(src = "") # a workaround that suppresses an error message otherwise
      }
    })
    
    output$evermore_image <- renderImage({
      if (input$albumFilter == "Evermore" | input$albumFilter == "All") {
        list(
          src = "images/evermore.png",
          contentType = "image/png"
        )} 
      else {
          list(src = "")
        }
    })
    
    output$midnights_image <- renderImage({
      if (input$albumFilter == "Midnights" | input$albumFilter == "All") {
        list(
          src = "images/midnights.png",
          contentType = "image/png"
        )} 
      else {
        list(src = "")
      }
    })
}

shinyApp(ui = ui, server = server)

