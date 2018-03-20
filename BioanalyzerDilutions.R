DilutionsforBioanalyzer <- function (x, C2, V2, Well) {

  filename <- read.csv(file = x, sep = ",", header=TRUE)
  
  C1 <- filename$Concentration
  V1 <- filename$Amount
  
  EBVolume <- round((V1*C1)/C2 - V1)
  
  head(EBVolume)
  
  for (i in 1:nrow(filename)) {
    if(EBVolume[i] < 0) {
      EBVolume[i] <- 0
    }
  }
  
  TotalVolume <- EBVolume + V1

  for (i in 1:nrow(filename)){
    
    repeat{
      
      if(TotalVolume[i] < V2) {
        EBVolume[i] <- EBVolume[i]*2
        V1[i] <- V1[i]*2
        TotalVolume[i] <- EBVolume[i] + V1[i]
      }
      else {
        break
      }
    }
  }
  
  filename$Amount <- V1
  
  FinalConcentration <- (V1*C1)/(V1+EBVolume)
  
  NetDNAinWell <- FinalConcentration*Well
  
  dat <- cbind(filename, EBVolume, TotalVolume, FinalConcentration, NetDNAinWell)
  
  write.csv(dat, file = "DilutionsforBioanalyzer.csv")
}

