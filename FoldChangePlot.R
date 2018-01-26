HeatandBar <- function(x) {
  
  #Load libraries
  library(ggplot2)
  library(RColorBrewer)
  
  #Read in file and reorder the levels
  filename <- read.csv(file = x, sep = ",", header=TRUE)
  filename$Sample.Condition <- factor(filename$Sample.Condition, 
                                      levels = c("No Antibody", "H3K27me3", "Anti-GFP"))
  
  #Plot heatmap
  heatmap1 <- ggplot(filename, aes(x=Sample.Condition, y=Gene, fill=Fold.Change)) + 
    theme_classic(base_size = 16) + geom_tile(aes(fill = Fold.Change)) +
    scale_fill_gradient2(low = "blue", high = "red", mid="white", 
                         midpoint = 1, limits = c(0.2,5)) +
    xlab("Sample Condition") + ylab("Gene") + labs(fill="Fold Change\n") 
  
  ggsave(plot = heatmap1, filename = "heatmap05.png", width = 6, height = 4)
  
  #Plot bargraph
  FoldChangeBar <- ggplot(filename, aes(x=Sample.Condition, y=Fold.Change, fill=Gene)) + 
    theme_classic(base_size = 16) +
    xlab("Sample Condition") + ylab("Fold Change") +
    geom_bar(position='dodge', stat='identity', color='black') +
    geom_errorbar(aes(ymin=Fold.Change-Stdev, ymax=Fold.Change+Stdev), 
                  width=.2, position = position_dodge(0.9)) +
    geom_hline(yintercept = 1, linetype=2, size=1) +
    scale_fill_brewer(palette="Pastel1")
  
  ggsave(plot = FoldChangeBar, filename = "bargraph.png")
  
}
