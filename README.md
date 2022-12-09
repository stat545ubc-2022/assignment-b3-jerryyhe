# README.md

Repository for STAT545B that contains the source code for the ShinyApp: Taylor Swift - From Folklore to Midnights Streaming Statistics. 

## Link to ShinyApp
#### Assignment B3
https://jerryhe.shinyapps.io/assignment-b3-jerryyhe/

#### Assignment B4 
https://jerryhe.shinyapps.io/assignment-b4-jerryyhe/

## Option B
I chose option B for this assignment B3. 

## Description of ShinyApp
The Assignment B3 ShinyApp allows the user to interactively view Spotify streaming statistics of Taylor Swift's most recent three albums: Folklore, Evermore, and Midnights. The app shows the user plots of the number of streams for each song in the respective albums, the datatable used to generate the plot, and allows the user to filter through them. Additionally, it also show pictures of the albums. 

The Assignment B4 ShinyApp performs the same basic functionalities as the Assignment B3 ShinyApp. It has been upgraded to include interactive plots for easy viewing of streaming statistics as well as to include album descriptions for each album. 

## Dataset Used
The dataset used for this ShinyApp is available in this repo as `taylor_swift_song_streams.csv`. This data was compiled manually by myself using stream numbers obtained from Spotify. As such, the streaming stats are only updated as of November 25, 2022. 

## Files
### README.md
The file you're reading. 

### app.R
The R code used to generate the running instance of the ShinyApp for Assignment B3. 

### appb4.R
The R code used to generate the runniing instance of the ShinyApp for Assignment B4. 

### taylor_swift_song_streams.csv
The dataset used for this ShinyApp

### images
A directory containing the three album cover images used in the ShinyApp

## Running this Code
The code in this repo can be run locally by cloning this Git repository. We recommend you use RStudio to run our code (since our code is all in R). To do this, open RStudio -> go to New Project in the upper right corners -> Click Version Control -> Git -> enter the repository URL and you are all set. The repository URL can be found under the Code tab in our repository.
