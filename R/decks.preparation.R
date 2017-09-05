#!/usr/bin/env Rscript
execution.start.time <- Sys.time()
if(!interactive()){
  initial.options <- commandArgs(trailingOnly = FALSE)
  file.arg.name <- "--file="
  script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
  script.basename <- file.path(dirname(script.name), "..")
  setwd(script.basename)
  
  message(paste("The working dir has been set to", script.basename))
}

#######################
# Requirements & Setup
##
if (!require("pacman")) install.packages("pacman"); library(pacman)
invisible(p_load("dplyr"))

ritual.labels.en <- list(
  "STUDY" = "Study",
  "TRASMUTATION" = "Trans",
  "SACRIFICE" = "Sacrifice"
)

ritual.labels.it <- list(
  "STUDY" = "Studio",
  "TRASMUTATION" = "Trans",
  "SACRIFICE" = "Sacrifice"
)

type.labels.en <- list(
  "C" = "Continuos",
  "I" = "Immediate",
  "A" = "Activation"
)

type.labels.it <- list(
  "C" = "Continuo",
  "I" = "Immediato",
  "A" = "Attivazione"
)

picture.placeholder <- "picture.placeholder.png"
ritual.placeholder <- "icon.blank.png"

standard.deck <- read.csv(file="./data/standard.deck.csv", stringsAsFactors = FALSE)
deck.families.meta <- read.csv(file="./data/deck.families.meta.csv", stringsAsFactors = FALSE)
rituals.meta <- read.csv(file="./data/rituals.meta.csv", stringsAsFactors = FALSE)
cards.meta <- read.csv(file="./data/cards.meta.csv", stringsAsFactors = FALSE, colClasses = c("character", "character"))

####################
# Data Preparation
##

standard.deck.multi <- standard.deck %>% 
  left_join(deck.families.meta) %>%
  left_join(cards.meta) %>%
  left_join(rituals.meta) %>%
  mutate(picture = ifelse(is.na(picture), picture.placeholder, picture)) %>%
  mutate(ritual.icon = ifelse(is.na(ritual.icon), ritual.placeholder, ritual.icon))

standard.deck.en <- standard.deck.multi %>%
    mutate(type = unlist(type.labels.en[type])) %>%
    mutate(ritual.description = ifelse(nchar(ritual)>0, paste(ritual.labels.en[["STUDY"]], ": ",
                                      ritual.study, "; ",
                                      ritual.labels.en[["TRASMUTATION"]], ": ",
                                      ritual.trasmutation, "; ",
                                      ritual.labels.en[["SACRIFICE"]], ": ",
                                      ritual.sacrifice, sep=""),
                                      "")) %>%
    mutate(title = title.en) %>%
    mutate(description = description.en) %>%
    mutate(caption = caption.en) %>%
    select(card, card.id, family, background, title, description, type, caption, knowledge.points, ritual.icon, picture, ritual.description )
write.csv(standard.deck.en, file = "./data/woc.deck.en.csv", row.names = FALSE, na = "")

message(paste("\n\t############################\n",
              "\t# DECK: Standard Deck (EN)",
              "\n\t#",
              "\n\t# DIMENSION: ", NROW(standard.deck.en), " cards",
              "\n\t# FAMILIES: ", paste(unique(standard.deck.en$family), collapse=", "),
              "\n\t# STATUS: READY",
              "\n\t###########\n", sep=""))

standard.deck.it <- standard.deck.multi %>%
  mutate(type = unlist(type.labels.it[type])) %>%
  mutate(ritual.description = ifelse(nchar(ritual)>0, paste(ritual.labels.it[["STUDY"]], ": ",
                                                            ritual.study, "; ",
                                                            ritual.labels.it[["TRASMUTATION"]], ": ",
                                                            ritual.trasmutation, "; ",
                                                            ritual.labels.it[["SACRIFICE"]], ": ",
                                                            ritual.sacrifice, sep=""),
                                     "")) %>%
  mutate(title = title.it) %>%
  mutate(description = description.it) %>%
  mutate(caption = caption.it) %>%
  mutate(ritual.description = gsub("FW", "SP", ritual.description)) %>%
  mutate(ritual.description = gsub("AS", "SA", ritual.description)) %>%
  mutate(ritual.description = gsub("DM", "MO", ritual.description)) %>%
  mutate(ritual.description = gsub("OBS", "OSS", ritual.description)) %>%
  mutate(ritual.description = gsub("RIS", "RIC", ritual.description)) %>%
  mutate(ritual.description = gsub("EN", "EN", ritual.description)) %>%
  select(card, card.id, family, background, title, description, type, caption, knowledge.points, ritual.icon, picture, ritual.description )
write.csv(standard.deck.it, file = "./data/woc.deck.it.csv", row.names = FALSE, na = "")

message(paste("\n\t############################\n",
              "\t# DECK: Standard Deck (IT)",
              "\n\t#",
              "\n\t# DIMENSION: ", NROW(standard.deck.it), " cards",
              "\n\t# FAMILIES: ", paste(unique(standard.deck.it$family), collapse=", "),
              "\n\t# STATUS: READY",
              "\n\t###########\n", sep=""))
