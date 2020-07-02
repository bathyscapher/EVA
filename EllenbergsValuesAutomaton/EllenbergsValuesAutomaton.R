################################################################################
################################################################################
################################################################################
################################################################################
### Match Ellenberg's indicator values with a given set of species
################################################################################


library("plyr")


rm(list = ls())


setwd("~/EVA/EllenbergsValuesAutomaton/")


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
## Replace accented letters
vascu$SpeciesShort <- chartr("áéíóúňäöü", "aeiounaou", vascu$Species)


## Delete abbreviated author names
vascu$SpeciesShort <- gsub("[A-Z]{1,2}[a-z]*\\.", "", vascu$SpeciesShort,
                            perl = TRUE)


## Delete author names
vascu$SpeciesShort <- gsub(" [A-Z]{1,2}[a-z]*", "",
                            vascu$SpeciesShort, perl = TRUE)


## Delete ampersands
vascu$SpeciesShort <- gsub("\\&", "", vascu$SpeciesShort, perl = TRUE)


## Delete brackets and trailing white space
vascu$SpeciesShort <- gsub(" *$", "", gsub("\\(\\)", "", vascu$SpeciesShort))


## Delete author names in brackets
vascu$SpeciesShort <- gsub("\\([A-Z]{1,2}[a-z]* *\\)", "",
                            vascu$SpeciesShort, perl = TRUE)


## Reduce multiple spaces
vascu$SpeciesShort <- gsub(" {2,}", " ", vascu$SpeciesShort)


# levels(as.factor(vascu$SpeciesShort))


## Get column number + 1
cols <- dim(vascu)[2] + 1


## Add empty columns for Ellenberg's values to species list
vascu$CheckPoint <- NA
vascu[names(ev[2:11])] <- NA


################################################################################
### Fuzzy match by species. Set cost to conserve names (no insertions and
### substitutions, deletions allowed)
gotem <- lapply(vascu$SpeciesShort, agrep, x = ev$Name, value = FALSE,
                max.distance = c(all = 1,
                                 deletions = 2,
                                 insertions = 2,
                                 substitutions = 0))


################################################################################
### Fill Ellenberg's values into vascu
EVA <- function(matches, index){
  if(length(matches) == 1)
    {vascu[index, cols:(cols + 10)] <- ev[matches, ]}
  else
    {vascu[index, cols:(cols + 10)] <- c(paste(length(matches), "match(es)"),
                             rep(NA, 10))}
  }


## Update target data.frame
vascu[, cols:(cols + 10)] <- do.call(rbind, Map(EVA, gotem, seq_along(gotem)))


## Revise mismatches
mismatches <- vascu[grep("match", vascu$CheckPoint), ]

levels(as.factor(mismatches$SpeciesShort))


################################################################################
################################################################################
################################################################################
################################################################################
