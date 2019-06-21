#!/usr/bin/Rscript

## USAGE ##
#Rscript concat_table.R --arg1="Total.Cites"


## Collect arguments
args <- commandArgs(TRUE)

parseArgs <- function(x) strsplit(sub("^--", "", x), "=")
argsDF <- as.data.frame(do.call("rbind", parseArgs(args)))
argsL <- as.list(as.character(argsDF$V2))
names(argsL) <- argsDF$V1



## Arg1 default
if(is.null(as.character(unlist(argsL[1]))) ) {
  writeLines("Pas le bon terme")
  q(save="no")
} else {
  types <- as.character(unlist(argsL[1]))
}

library(tidyverse)

directory <- BasePath
types <- "Total.Cites"
fichier <- fichiers[2]


Concat_files <- function(directory, types){
  # boucle for
  if (missing(directory)) stop("directory is missing")
  fichiers <- list.files(path=directory,
                         pattern="*.csv")
  if (length(c(types)) == 1) {
    for (fichier in fichiers) {
      datas <- read.table(paste0(directory, fichier),
                          header = T, dec = ".", sep = ",", stringsAsFactors=F)
      # Construction du vecteur avec les noms des fichiers
      fichier <-  gsub("_InCites_journal_citation_Reports.csv","",fichier)
      # Géré les noms des colonnes
      if (exists("Names_VC") == FALSE) {
        Names_VC <- c("Full.Journal.Title")
      }
      Names_VC <- append(Names_VC, fichier) 
      #colnames(datas) <- c("Full.Journal.Title", "Total.Cites", "Journal.Impact.Factor", "Eigenfactor.Score")
      # Géré les exception pour les SNP rm(VCallingDataSet)
      if (exists("VCallingDataSet") == FALSE) {
        VCallingDataSet <- data.frame(matrix("A", nrow = 1, ncol = ncol(datas[c("Full.Journal.Title", types)])))
        colnames(VCallingDataSet) <- c(colnames(datas)[1], "COL_RM")
        #VCallingDataSet <- VCallingDataSet[c("Full.Journal.Title", "COL_RM")] # Mettre un paramètre ici
        VCallingDataSet <- VCallingDataSet %>%
          full_join(datas[c("Full.Journal.Title", types)])
        VCallingDataSet <- VCallingDataSet[,-2]
        VCallingDataSet <- VCallingDataSet[-1,]
      } else {
      VCallingDataSet <- VCallingDataSet %>%
        full_join(datas[c("Full.Journal.Title", types)])
      }
      colnames(VCallingDataSet) <- Names_VC
      #rm(VCallingDataSet)
    }
    #VCallingDataSet[is.na(VCallingDataSet)] <- as.numeric(0)
    return(VCallingDataSet)
  } else if (length(c(types)) == 2) {
    writeLines("A dévelopé")
  } else {
    stop("To much argument for Type")
  }
}

BasePath <- "~/Documents/BibliographeR/raw/SCIE/"

#tableau <- Concat_files(BasePath, "Total.Cites")
write.table(tableau, file = paste0(BasePath,"concat_",Total.Cites,".csv"), dec = ",", sep = "\t", quote = FALSE, row.names = FALSE)

types <-"Journal.Impact.Factor"
tableau <- Concat_files(BasePath, types)
write.table(tableau, file = paste0(BasePath,"concat_",types,".csv"), dec = ",", sep = "\t", quote = FALSE, row.names = FALSE)

types <-"Eigenfactor.Score"
tableau <- Concat_files(BasePath, types)
write.table(tableau, file = paste0(BasePath,"concat_",types,".csv"), dec = ",", sep = "\t", quote = FALSE, row.names = FALSE)

