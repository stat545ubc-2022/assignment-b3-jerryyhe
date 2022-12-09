library(shiny)
library(tidyverse)
library(bslib)
library(plotly)

# Data
data <- read_csv("taylor_swift_song_streams.csv") %>% 
  mutate(across(c(Year, Streams), as.integer), Album = factor(Album), Title = fct_reorder(Title, Streams, .desc = TRUE)) 

# Descriptions
folkloreDescription <- "A mere 11 months passed between the release of Lover and its surprise follow-up, but it feels like a lifetime. Written and recorded remotely during the first few months of the global pandemic, folklore finds the 30-year-old singer-songwriter teaming up with The National’s Aaron Dessner and longtime collaborator Jack Antonoff for a set of ruminative and relatively lo-fi bedroom pop that’s worlds away from its predecessor. When Swift opens “the 1”—a sly hybrid of plaintive piano and her naturally bouncy delivery—with “I’m doing good, I’m on some new st,” you’d be forgiven for thinking it was another update from quarantine, or a comment on her broadening sensibilities. But Swift’s channelled her considerable energies into writing songs here that double as short stories and character studies, from Proustian flashbacks (“cardigan,” which bears shades of Lana Del Rey) to outcast widows (“the last great american dynasty”) and doomed relationships (“exile,” a heavy-hearted duet with Bon Iver’s Justin Vernon). It’s a work of great texture and imagination. “Your braids like a pattern/Love you to the moon and to Saturn,” she sings on “seven,” the tale of two friends plotting an escape. “Passed down like folk songs, the love lasts so long.” For a songwriter who has mined such rich detail from a life lived largely in public, it only makes sense that she'd eventually find inspiration in isolation."
evermoreDescription <- "Surprise-dropping a career-redefining album in the midst of a paralyzing global pandemic is an admirable flex; doing it again barely five months later is a display of confidence and concentration so audacious that you’re within your rights to feel personally chastised. Like folklore, evermore is a team-up with Aaron Dessner, Jack Antonoff, and Justin Vernon, making the most of cozy home-studio vibes for more bare-bones arrangements and bared-soul lyrics, casually intimate and narratively rich.
There is an expanded guest roster here—HAIM appears on “no body, no crime,” which seems to place Este Haim in the centre of a small-town murder mystery, while Dessner’s bandmates in The National are on “coney island”—but they fit themselves into the mood rather than distract from it. (The percussive “long story short” sounds like it could have been on any National album in the past decade.) Elsewhere, “'tis the damn season” is the elegaic home-for-the-holidays ballad this busted year didn’t realize it needed. But while so much of folklore’s appeal involved marvelling at how this setting seemed to have unlocked something in Swift, the only real shock here is the timing of the release itself. Beyond that, it’s an extension and confirmation of its predecessor’s promises and charms, less a novelty driven by unprecedented circumstances and instead simply a thing she happens to do and do well."
midnightsDescription <- "Let‘s start with that speech. In September 2022, as Taylor Swift accepted Songwriter-Artist of the Decade honours at the Nashville Songwriter Awards, the headline was that Swift had unveiled an admittedly “dorky” system she’d developed for organizing her own songs. Quill Pen, Fountain Pen, Glitter Gel Pen: three categories of lyrics, three imagined tools with which she wrote them, one pretty ingenious way to invite obsessive fans to lovingly obsess all the more.
And yet, perhaps the real takeaway was the manner in which she spoke about her craft that night, some 20 years after writing her first song at the age of 12. “I love doing this thing we are fortunate enough to call a job,” she said to a room of her peers. “Writing songs is my life’s work and my hobby and my never-ending thrill. A song can defy logic or time. A good song transports you to your truest feelings and translates those feelings for you. A good song stays with you even when people or feelings don’t.”
On Midnights, her tenth LP and fourth in as many years—if you don’t count the two she’s just re-recorded and buttressed with dozens of additional tracks—Swift sounds like she’s really enjoying her work, playing with language like kids do with gum, thrilling to the texture of every turn of phrase, the charge in every melody and satisfying rhyme. Alongside longtime collaborator Jack Antonoff, she’s set out here to tell “the stories of 13 sleepless nights scattered throughout [her] life,” as she phrased it in a message to Apple Music subscribers. It’s a concept that naturally calls for a nocturnal palette: slower tempos, hushed atmosphere, negative space like night sky. 
The sound is fully modern (synths you’d want to eat or sleep in, low end that sits comfortably on your chest), while the aesthetic (soft focus, wood panelling, tracklist on the cover) is decidedly mid-century, much like the Mad Men-inspired title of its brooding opener, “Lavender Haze”—a song about finding refuge in the glow of intimacy. “Talk your talk and go viral,” she sings, in reference to the maelstrom of outside interest in her six-year relationship with actor Joe Alwyn. “I just want this love spiral.” (A big shout to Antonoff for those spongy backup vocals, btw.) 
In large part, Midnights is a record of interiors, Swift letting us glimpse the chaos inside her head (“Anti-Hero,” wall-to-wall zingers) and the stillness of her relationship (“Sweet Nothing,” co-written by Alwyn under his William Bowery pseudonym). For “Snow on the Beach,” she teams up with Lana Del Rey—an artist whose instinct for mood and theatrical framing seems to have influenced Swift’s recent catalogue—recalling the magic of an impossible night over a backdrop of pizzicato violin, sleigh bells, and dreamy Mellotron, like the earliest hours of Christmas morning. “I’ve never seen someone lit from within,” Swift sings. “Blurring out my periphery.” 
But then there’s “Bejeweled,” a late, 1989-like highlight on which she announces to an unappreciative partner, a few seconds in: “And by the way, I’m going out tonight.” And then out Swift goes, striding through the centre of the song like she would the room: “I can still make the whole place shimmer,” she sings, relishing that last word. “And when I meet the band, they ask, ‘Do you have a man?’/I could still say, ‘I don’t remember.’” There are traces of melancholy layered in (see: “sapphire tears on my face”), but the song feels like a triumph, the sort of unabashed, extroverted fun that would have probably seemed out of place in the lockdown indie of 2020’s folklore and evermore. But here, side by side with songs and scenes of such writerly indulgence, it’s right at home—more proof that the terms “singer-songwriter” and “universal pop star” aren’t mutually exclusive ideas. “What’s a girl gonna do?” Swift asks at its climax. “A diamond’s gotta shine.”
This special expanded version of Midnights includes seven additional songs."

# UI
ui <- fluidPage(
  # Set theme
  theme = bs_theme(version = 4, bootswatch = "cerulean"),
  
  # Title
  titlePanel("Taylor Swift: Folklore to Midnights Streaming Statistics"),

  # Layout
  sidebarLayout(
    # Sidebar Items
    sidebarPanel(
      fluidRow(
        column(12,
          wellPanel(
            # Feature 1: Option to filter for album of interest or selectively view songs that have been streamed x amount of times
            selectInput("albumFilter", "Choose an album", c("All", "Folklore", "Evermore", "Midnights")),
            sliderInput("streamFilter", "Filter by number of streams", min = 0, max = 300000000, value = c(0, 300000000), step = 500000),
          ),
          br(),
          # New feature: Add an album description when selecting an album 
          wellPanel(
            h2("Album Description"),
            helpText("Select an album to view its description."),
            textOutput("Description")
        )
      )
    )
  ),
    
    # MainPanel Items
    mainPanel(
      
      # Feature 2: Add images for respective albums. Useful as an easy, visual feature for the user to identify each album with
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
                 plotlyOutput("song_streams")),
        tabPanel("Table",
                 DT::dataTableOutput("data_table"))
      )
    )
  )
)


# Server
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
    # New feature: Output plot. Plot the output of the dynamic data. Plots are now interactive
    output$song_streams <- renderPlotly({
      ggplotly(
      filtered_data() %>% 
        ggplot(aes(x = Title, y = Streams)) +
        geom_col() +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        scale_y_continuous(breaks = seq(0, 300000000, by = 50000000)) +
        labs(x = "Songs", y = "Number of Streams")
      )})
    
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
    
    # New feature: Add an album description when selecting an album
    output$Description <- renderText({
      if (input$albumFilter == "Folklore") folkloreDescription
      else if (input$albumFilter == "Evermore") evermoreDescription
      else if (input$albumFilter == "Midnights") midnightsDescription
    })
}

shinyApp(ui = ui, server = server)

