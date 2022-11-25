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
      selectInput("albumFilter", "Choose an album", c("All", "Folklore", "Evermore", "Midnights")),
      sliderInput("streamFilter", "Filter by number of streams", min = 0, max = 300000000, value = c(0, 300000000), step = 500000)
    ),
    
    # MainPanel Items
    mainPanel(
      
      # Divide images onto one line
      div(style="display:flex;",
          imageOutput("folklore_image", width = "25vw"),
          imageOutput("evermore_image", width = "25vw"),
          imageOutput("midnights_image", width = "25vw")
      ),
      
      # Tabs for plot and table
      tabsetPanel(
        tabPanel("Plot",
                 plotOutput("song_streams")),
        tabPanel("Table",
                 tableOutput("data_table"))
      )
    )
  )
)



server <- function(input, output) {
  
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
    
    # Output plot
    output$song_streams <- renderPlot({
      filtered_data() %>% 
        ggplot(aes(x = Title, y = Streams)) +
        geom_col() +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        scale_y_continuous(breaks = seq(0, 300000000, by = 50000000)) +
        labs(x = "Songs", y = "Number of Streams")
      })
    
    # Output data table
    output$data_table <- renderTable({
      filtered_data() %>% 
        arrange(desc(Streams))
      })
    
    # Output images. If album filter is applied, then only show that image
    output$folklore_image <- renderImage({
      if (input$albumFilter == "Folklore" | input$albumFilter == "All") {
        list(
          src = "images/folklore.png",
          contentType = "image/png"
        )} 
      else {
        list(src = "")
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

