library(tidyverse)
plotTheme <- theme_classic(base_size = 16) + 
        theme(panel.background = element_rect(fill = "transparent"),
              plot.background = element_rect(fill = "transparent"),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              legend.background = element_rect(fill = "transparent"),
              legend.box.background = element_rect(fill = "transparent"))

theme_set(plotTheme)

setwd("~/../Downloads/")
dat <- read.delim("008 DMV Droplet Volume.txt", skip = 8)
markerRow <- which(dat$Droplet.ID == "ENTIRE POPULATION")

lastRow <- markerRow - 2

dat.1 <- dat[c(1:lastRow),]

summary(dat.1)

meltDat <- reshape2::melt(dat.1)

test <- ggplot(meltDat, aes(x = value)) + 
        geom_histogram(bins = 40) + 
        facet_wrap(~variable, scales = "free")
        

ggsave(filename = "test.png", plot = test, bg = "transparent")