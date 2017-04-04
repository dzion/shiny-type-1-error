library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
    output$pvalPlot <- renderPlot({
        
        input$goButton
        pvals <- NULL
        
        for (i in seq(1:input$simrun)){
          #  set.seed(78978 + i ) #+input$goButton)  ##2329 , 78978 # 78932
            y <-  rnorm(input$sample_size, 50, 10)
            x <- sample(c(0,1), input$sample_size, replace=T)
            pvals <- rbind(pvals,summary(lm(y~x))$coefficients[2,4])
        }
        
        psort <- sort(pvals)
        p.data <- as.data.frame(psort)
        p.data$nr <- seq_along(psort)
        p.data$color <- ifelse(p.data$psort <0.01, "1%",
                                         ifelse(p.data$psort <0.05, "5%",
                                                p.data$color <- ifelse(p.data$psort <0.1, "10%", "p>0.1")))
        
        
        ggplot(p.data, aes(x=nr, y=psort, color = color)) + 
            geom_point() + 
            scale_colour_discrete(drop=TRUE,
                                  limits = levels(p.data$color)) +
            theme_bw() + 
            labs(color = "P-Value Colours",
                 x = "Sample Number",
                 y = "P-Value") +
            scale_y_continuous( limits = c(0, 1)) +
            geom_hline(aes(yintercept = 0.05), color = "#000099") + 
            geom_hline(aes(yintercept =  0.1), color = "#990099") + 
            geom_hline(aes(yintercept = 0.01), color = "#009999")

    })
})