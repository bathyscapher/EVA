################################################################################
################################################################################
################################################################################
################################################################################
### Match Ellenberg's indicator values with a species list
################################################################################


library("plyr")


rm(list = ls())


setwd("~/EVA/")


################################################################################
### Read Ellenberg's values
ev <- lapply(list.files(pattern = "Ellenberg.*.csv"), read.delim, sep = "\t")


## Convert list of data.frames to data.frame
ev <- rbind.fill(ev)


## Resort columns
ev <- ev[c("Name", "L", "T", "K", "F", "R", "N", "S", "LF", "LF_B", "SUB")]


## Reformat columns
ev[, 2:11] <- as.data.frame(apply(ev[, 2:11], 2,
                                  function(x) gsub("\\?|x", NA, x)))
ev[, 2:11] <- as.data.frame(apply(ev[, 2:11], 2,
                                  function(x) gsub("-|B|b|~|=|\\(|)", "", x)))
ev[, c(2:8)] <- as.data.frame(apply(ev[, c(2:8)], 2, as.integer))


################################################################################
### Read vegetation list
vascu <- read.table("PlantList.csv", sep = "\t", header = TRUE)


### Format species names
## Delete all abbreviated author names
vascu$SpeciesShort <- gsub("[A-Z]{1,2}[a-z]*\\.", "", vascu$Species,
                           perl = TRUE)


## Delete all ampersands
vascu$SpeciesShort <- gsub("\\&", "", vascu$SpeciesShort, perl = TRUE)


## Delete all  author names (match characters in a wide accented range)
vascu$SpeciesShort <- gsub("[A-Z]{1,2}[a-zà-ÿ]* *$", "",
                           vascu$SpeciesShort, perl = TRUE)


## Delete brackets and trailing white space
vascu$SpeciesShort <- gsub(" *$", "", gsub("\\(\\)", "", vascu$SpeciesShort))


## Add empty columns for Ellenberg's values to species list
vascu$CheckPoint <- NA
vascu[names(ev[2:11])] <- NA


################################################################################
### Fuzzy match by species. Set cost to conserve names (no insertions and
### substitutions, deletions allowed)
gottem <- lapply(vascu$SpeciesShort, agrep, x = ev$Name, value = FALSE,
                 max.distance = c(all = 1,
                                  deletions = 2,
                                  insertions = 2,
                                  substitutions = 0))


################################################################################
### Fill Ellenberg's values into vascu
EVA <- function(matches, index){
  if(length(matches) == 1)
    {vascu[index, 5:15] <- ev[matches, ]}
  else
    {vascu[index, 5:15] <- c(paste(length(matches), "match(es)"),
                             rep(NA, 10))}
  }


## Update target data.frame
vascu[, 5:15] <- do.call(rbind, Map(EVA, gottem, seq_along(gottem)))


## See mismatches
mismatches <- vascu[grep("match", vascu$CheckPoint), ]


################################################################################
################################################################################
################################################################################
################################################################################
