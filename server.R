library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
    output$pvalPlot <- renderPlot({
        
        input$goButton
        pvals <- NULL
        set.seed(78932 +input$goButton) ##2329 , 78978 # 78932
        y <-  rnorm(input$sample_size, 0, 1)
        for (i in seq(1:input$simrun)){
              ##2329 , 78978 # 78932
            x <- sample(c(0,1), input$sample_size, replace=T)
            pvals <- rbind(pvals,summary(lm(y~x))$coefficients[2,4])
        }
        
        psort <- sort(pvals)
        p.data <- as.data.frame(psort)
        p.data$psort <- p.adjust(p.data$psort, method = input$correction)
        p.data$nr <- seq_along(psort)
        p.data$color <- ifelse(p.data$psort <0.01, "p<0.01",
                                         ifelse(p.data$psort <0.05, "p<0.05",
                                                p.data$color <- ifelse(p.data$psort <0.1, "p<0.1", "p>0.1")))
        
        
        ggplot(p.data, aes(x=nr, y=psort, color = color)) + 
            geom_point() + 
            scale_colour_discrete(drop=TRUE,
                                  limits = levels(p.data$color)) +
            theme_bw() + 
            labs(color = "p-value colours",
                 x = "Hypothesis",
                 y = "p-value", 
                 title = "All hypotheses ordered by p-value") +
            scale_y_continuous( limits = c(0, 1)) +
            geom_hline(aes(yintercept = 0.05), color = "#999999") + 
            geom_hline(aes(yintercept =  0.1), color = "#999999") + 
            geom_hline(aes(yintercept = 0.01), color = "#999999")

    })
})