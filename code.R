# type I error simulation
library(ggplot2)
pvals <- NULL

for (i in seq(1:10)){
    set.seed(78932 + i)  ##2329 , 78978
    y <-  rnorm(100, 50, 10)
    x <- sample(c(0,1), 100, replace=T)
    pvals <- rbind(pvals,summary(lm(y~x))$coefficients[2,4])
}

psort <- sort(pvals)

# qplot(seq_along(psort), psort) + 
#     theme_bw() + 
#     geom_hline(aes(yintercept = 0.05, color = "#000099")) + 
#     geom_hline(aes(yintercept =  0.1, color = "#990099")) + 
#     geom_hline(aes(yintercept = 0.01, color = "#009999"))
#     
# 




psort <- sort(pvals)
p.data <- as.data.frame(psort)
p.data$nr <- seq_along(psort)
p.data$color <- as.factor(ifelse(p.data$psort <0.01, "1%",
                       ifelse(p.data$psort <0.05, "5%",
                              p.data$color <- ifelse(p.data$psort <0.1, "10%", NA))))


qplot(nr, psort, data = p.data, color = color) + 
    theme_bw() + 
    geom_hline(aes(yintercept = 0.05), color = "#000099") + 
    geom_hline(aes(yintercept =  0.1), color = "#990099") + 
    geom_hline(aes(yintercept = 0.01), color = "#009999") +
    scale_alpha(guide = 'none')





# psort <- sort(pvals)
# p.data <- as.data.frame(psort)
# p.data$nr <- seq_along(psort)
# p.data$color <- ifelse(p.data$psort <0.01, "1%",
#                        ifelse(p.data$psort <0.05, "5%",
#                               p.data$color <- ifelse(p.data$psort <0.1, "10%", NA)))
# 
# 
# 
# qplot(nr, psort, data = p.data, color = color) + 
#     theme_bw() + 
#     geom_hline(aes(yintercept = 0.05), color = "#000099") + 
#     geom_hline(aes(yintercept =  0.1), color = "#990099") + 
#     geom_hline(aes(yintercept = 0.01), color = "#009999") +
#     scale_alpha(guide = 'none')


