#!/usr/bin/Rscript

## Collect arguments
args <- commandArgs(TRUE)

parseArgs <- function(x) strsplit(sub("^--", "", x), "=")
argsDF <- as.data.frame(do.call("rbind", parseArgs(args)))
argsL <- as.list(as.character(argsDF$V2))
names(argsL) <- argsDF$V1

BasePath <- "~/Documents/BibliographeR/raw/"

## Arg1 default
if(is.null(as.character(unlist(argsL[1]))) ) {
  writeLines("Pas le bon terme")
  q(save="no")
} else {
  types <- as.character(unlist(argsL[1]))
}

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
      # Géré les exception pour les SNP
      if (exists("VCallingDataSet") == FALSE) {
        VCallingDataSet <- data.frame(matrix(NA, nrow = 1, ncol = ncol(datas)))
        colnames(VCallingDataSet) <- colnames(datas)
        VCallingDataSet <- VCallingDataSet[c("Full.Journal.Title", types)] # Mettre un paramètre ici
      }
      VCallingDataSet <- Reduce(function(x, y) merge(x = x, y = y, by = c("Full.Journal.Title"), all=TRUE),
                                list(VCallingDataSet,
                                     datas[c("Full.Journal.Title", types)] ) )
      if (ncol(VCallingDataSet) == 3 ) {
        if (sum(is.na(VCallingDataSet$Total.Cites.x)) == nrow(VCallingDataSet)) {
          if (TRUE %in% is.na(VCallingDataSet$Total.Cites.x)) {
            VCallingDataSet <- VCallingDataSet[,-1]
            VCallingDataSet <- VCallingDataSet[-nrow(VCallingDataSet),]
          }
        }
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

tableau <- Concat_files(BasePath, types)
write.table(tableau, file = paste0(BasePath,"/concat_",types,".csv"), dec = ",", sep = "\t", quote = FALSE, row.names = FALSE)