library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
    output$pvalPlot <- renderPlot({
        
        # go Button draws new sample data
            input$goButton
        # initialize new object for storage of pvalues
            pvals <- NULL
        # hard code seed that seem nice and add a new draw when goButton is pressed
            set.seed(78932 + input$goButton) ##2329 , 78978 # 78932   ##2329 , 78978 # 78932 
        # create a outcome from std. normal distribution 
            y <-  rnorm(input$sample_size, 0, 1)
        # create indep. variables and run linear model, extract p-values for beta_1 coeff. and store in pval vector
            for (i in seq(1:input$simrun)){
                x <- sample(c(0,1), input$sample_size, replace = TRUE)
                pvals <- rbind(pvals, summary(lm(y ~ x))$coefficients[2,4])
            }
        
            
        # sort p-vals ascending
            psort <- sort(pvals)
        # store p values in data frame
            p.data <- as.data.frame(psort)
        # replave p-values with adjusted pvalues according to the input option
            p.data$psort <- p.adjust(p.data$psort, method = input$correction)
        
        # create index
            p.data$nr <- seq_along(psort)
        
        # create factor variable for colorization of pvales
            p.data$color <- ifelse(p.data$psort <0.01, "p<0.01",
                                    ifelse(p.data$psort <0.05, "p<0.05",
                                       ifelse(p.data$psort <0.1, "p<0.1", "p>0.1")))
        
        # draw plot
            ggplot(p.data, aes(x=nr, y=psort, color = color)) + 
                geom_point() + # add points
                scale_colour_discrete(drop=TRUE,       # add colour
                                      limits = levels(p.data$color)) +
                theme_bw() + # use simple theme
                labs(color = "p-value colours", # describe graph
                     x = "Hypothesis",
                     y = "p-value", 
                     title = "All hypotheses ordered by p-value") +
                scale_y_continuous( limits = c(0, 1)) + # no expansion of y-limits 
                geom_hline(aes(yintercept = 0.05), color = "#999999") + # add lines for standard p-vals for analysis
                geom_hline(aes(yintercept =  0.1), color = "#999999") + 
                geom_hline(aes(yintercept = 0.01), color = "#999999")

    })
})