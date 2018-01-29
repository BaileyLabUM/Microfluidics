#This function takes the raw qPCR data received from the sequencing core and 
#outputs a csv file with the Ct values in each well. 
#To use function: qPCRWellPlate("filename.txt")

qPCRWellPlate <- function(x) {
  
  library(tidyr)
  
  #Create Wellplate 
  wellplate <- data.frame(matrix(as.numeric(), nrow = 16, ncol = 24))
  rownames(wellplate) <- toupper(letters[1:16])
  colnames(wellplate) <- c(1:24)
  head(wellplate)
  
  #Read and tidy file
  qPCR <- read.delim(file = x, sep = "\t", skip = 10)
  markerrow <- which(qPCR$Well == "Slope")
  lastrow <- markerrow - 1
  qPCR.1 <- qPCR[c(1:lastrow),]
  
  #Separate Wells into letters and numbers
  qPCR.2 <- separate(data = qPCR.1, col = Sample.Name, into = c("Row", "Column"), sep = 1)
  
  #Condense Data into wells we care about
  Row <- qPCR.2$Row
  Column <- qPCR.2$Column
  Ct <- qPCR.2$Ct
  dat <- data.frame(Row, Column, Ct)
  
  #Convert "Undetermined" to 0 and letters to numbers
  dat$Ct <- as.character(dat$Ct)
  dat[dat == "Undetermined"] <- 0
  
  dat$Row <- as.numeric(dat$Row)
  
  #Paste values from excel sheet into well plate format 
  for(i in 1:16) {
    for(j in 1:24) {
      CtValue <- which(dat$Row == i & dat$Column == j)
      wellplate[i,j] <- dat[CtValue, 3]
    }
  }
  
  #Save wellplate with values
  write.csv(wellplate, file = "qPCR Wellplate.csv")
}
