library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Type I Error Simulation"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("simrun",
                        "Number of Hypotheses:",
                        min = 1,
                        max = 150,
                        value = 100),
            sliderInput("sample_size",
                         "Samplesize:",
                         min = 50,
                         max = 1000,
                         value = 100),
            actionButton("goButton", "Draw new data")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("pvalPlot")
        )
    )
))