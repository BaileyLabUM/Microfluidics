#This function works if you first set your working directory to the file with the DMV outputs. Then use: 
#WorkingFiles <- list.files(pattern = ".txt")
#Then source the code and run PlotMyDMV(WorkingFiles)

PlotMyDMV <- function(x) {
  
  library(ggplot2)
  Result = NULL
  
  for (i in x) {
    
    #Takes DMV file and removes header and footer
    dat <- read.delim(i, skip = 8)
    markerRow <- which(dat$Droplet.ID == "ENTIRE POPULATION")
    lastRow <- markerRow - 2
    dat.1 <- dat[c(1:lastRow),]
    
    #Compresses DMV file into columns that we care about
    Droplet.ID <- dat.1$Droplet.ID
    AmountMeasured <- dat.1$N
    AreaMean <- dat.1$Mean.1
    MeanPixelIntensity <- dat.1$Mean.2
    dat.2 <- data.frame(Droplet.ID, AmountMeasured, AreaMean, MeanPixelIntensity)
    
    #Naming Variables 
    NameofFile <- tools::file_path_sans_ext (i)
    VolumeFraction <- as.numeric(sub("%", "", NameofFile))
    PixelIntensityMean <- mean(MeanPixelIntensity)
    PixelIntensityStdev <- sd(MeanPixelIntensity)
    RelativeStdev <- PixelIntensityStdev/PixelIntensityMean*100
    NumberofDroplets <- length(Droplet.ID)
    
    #Save variable results into a data frame
    Result[[i]] <- data.frame(VolumeFraction, NumberofDroplets, PixelIntensityMean, PixelIntensityStdev, RelativeStdev)
  }
  
  #Bind rows from each volume fraction into one excel sheet
  CombinedData <- dplyr::bind_rows(Result)
  readr::write_csv(CombinedData, "CombinedData.csv")

  #plot Volume Fraction vs RelStdev
  dat.3 <- read.csv("CombinedData.csv")
  head(dat.3)
  plot <- ggplot(dat.3, aes(x=VolumeFraction, y=RelativeStdev)) + 
    geom_col(color="black", fill="gray") + 
    labs(x = "Volume Fraction (%)", y = "Relative Standard Deviation (%)") + 
    theme_classic(base_size = 16)
  
  #Save and display plot
  ggsave(plot, filename = "volFraction.png")
  plot
}
