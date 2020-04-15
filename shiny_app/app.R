library(reticulate)
library(shiny)
library(plotly)
library(readr)
library(DT)
library(tidytext)


# import python functions -------------------------------------------------
use_python("/Library/Frameworks/Python.framework/Versions/3.7/bin/python3")
source_python('w2v_function.py')

# test = 'hello baby bro'
# create_3d_df(test, 1)

# UI ----------------------------------------------------------------------
ui <- fluidPage(

    # Application title
    titlePanel("Word Embedding visualizer"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          fileInput("file", h3("File input"), placeholder = 'upload here your txt file'), #add width = 300 for instance to make the panel bigger
          hr(), 
          textInput('similar', 'Extract the similar words', placeholder = 'type here the word'), 
          actionButton('id', 'Show similar words'),
          hr(),
          DTOutput('dataframe')
        ),

        # Show a plot of the generated distribution
        mainPanel(
          h3('t-SNE visualization'),
          plotlyOutput('three_d_w_to_v', height = '500px')
        )
    )
)



# server  -----------------------------------------------------------------
server <- function(input, output) {
  
  output$three_d_w_to_v <- renderPlotly({
    file1 <- input$file
    if (!is.null(file1)) {
      test <- read_file(file1$datapath) #I have to read the file as if I was importing it
      df <- create_3d_df(test, 1)
      df$names <- rownames(df)
      cleansed_data <- df %>% 
        filter(!names %in% stop_words$word)
      
      plot_ly(
        cleansed_data, x = ~x, y = ~y,  z = ~z, mode = 'text', text = cleansed_data$names, textposition = 'middle right',
        textfont = list(color = '#000000', size = 11)) %>%
        add_markers()
    } 
  })
  
  output$dataframe <- renderDT({
    if (input$id) {
      file1 <- input$file
      test <- read_file(file1$datapath) #I have to read the file as if I was importing it
      df <- create_3d_df(test, 1)
      df$names <- rownames(df)
      cleansed_data <- df %>% 
        filter(!names %in% stop_words$word)
      
      list <- similar_words(test, 1, input$similar)
      cleansed_data %>%
        filter(names %in% list) %>% 
        select(names)
    }
  })
  
}


# run the app -------------------------------------------------------------
shinyApp(ui = ui, server = server)
