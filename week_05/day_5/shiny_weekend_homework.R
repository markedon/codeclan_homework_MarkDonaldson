library(CodeClanData)
library(dplyr)
library(ggplot2)
library(shiny)
library(data.table)
library(shinythemes)
library(gganimate)



ui <- fluidPage(
  
  theme = shinytheme("superhero"),
  
  titlePanel(tags$b("Video Games 1988-2018")),
  
  
  tabsetPanel(
    
    tabPanel(
      "Find Games",
      column(4,
             selectInput("genre",
                         "Choose genre",
                         choices = unique(game_sales$genre))
      ),
      column(4,
             selectInput("year",
                         "Choose year",
                         choices = unique(game_sales$year_of_release))  
      ),
      column(4,
             selectInput("developer",
                         "Choose developer",
                         choices = unique(game_sales$developer))
      ),
      column(4,
             selectInput("platform",
                         "Choose platform",
                         choices = unique(game_sales$platform))
      ),
      
      actionButton("update", "Find game"),
      
      DT::dataTableOutput("table_output")
    ),
    
    tabPanel(
      "Score Comparison",
      
      column(4,
             
             plotOutput("scatter")),
      
      
      sidebarPanel(
        
        sliderInput("transparency",
                    "Transparency",
                    min = 0, max = 1, value = 0.8)
      )
      
      
      
    ),
    
    tabPanel(
      
      "Nintendo sales since 2000",
      
      
      tags$br(actionButton("update1", "Click")),
      
      tags$br(plotOutput("line"))       
      
    )
    
  )
)    


server <- function(input, output) {
  
  game_data <- eventReactive(input$update, {
    
    game_sales %>%
      filter(genre == input$genre)  %>%
      filter(year_of_release == input$year) %>%
      filter(developer == input$developer) %>%
      filter(platform == input$platform) %>% 
      slice(1:10) %>%
      mutate(round((user_score * 10)))
    
    
  })
  
  output$table_output <- DT::renderDataTable({
    game_data() 
    
  })
  
  game_data2 <- reactive({
    
    game_sales
    
  })
  
  output$scatter <- renderPlot({
    ggplot(game_data2()) +
      aes(x = critic_score,
          y = user_score) +
      labs(x = "Critic Score", y = "User Score") +
      geom_point(alpha = input$transparency) +
      theme(panel.background = element_rect(fill = "lightblue",
                                            colour = "lightblue",
                                            size = 0.5, linetype = "solid"),
            panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                            colour = "white"), 
            panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                            colour = "white"))
    # I thought it would be interesting for the user to see how user score compared with crititc score and whether the two correlated
    #the user will see that often they do and so could reasonably base judgement on a game using either score.
  })
  
  nintendo_data <- eventReactive(input$update1, {
    
    game_sales %>%
      filter(publisher == "Nintendo")
    
  })
  
  output$line <- renderImage({
    
    outfile <- tempfile(fileext='.gif')
    
    nintendo_plot <- ggplot(nintendo_data(), aes(year_of_release,
                                                 sales,
                                                 fill = publisher)) +
      geom_line() +
      expand_limits(x= 2000)+
      labs(x = "Year", y = "Sales (m)", title = "Nintendo Sales Since the Begninning of the Millennium") +
      theme(panel.background = element_rect(fill = "lightblue",
                                            colour = "lightblue",
                                            size = 0.5, linetype = "solid"),
            panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                            colour = "white"), 
            panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                            colour = "white")) +
      geom_point(aes(group = seq_along(year_of_release))) +
      transition_reveal(year_of_release, )
    
    
    # I chose to concentrate on the top publisher by sales Nintendo to demonstarate how their sales had flucuated since 2000 despite being top
    # I chose to animate the line graph to emphasise this fluctuation.              
    #Unfortunately it takes a while to render after activated by action button.
    
    anim_save("outfile.gif", animate(nintendo_plot)) # I had to include this code (149 to 156) in the funciton in order for the gif graph to work
    
    list(src = "outfile.gif",
         contentType = 'image/gif'
         
    )},
    
    deleteFile = TRUE)
  
  
}

# Run the app
shinyApp(ui = ui, server = server)
