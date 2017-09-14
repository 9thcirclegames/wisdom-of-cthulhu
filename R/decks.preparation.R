#!/usr/bin/env Rscript
execution.start.time <- Sys.time()
td <- NULL
if(nchar(Sys.getenv("TRAVIS_BUILD_DIR"))>0){
  setwd(Sys.getenv("TRAVIS_BUILD_DIR"))
  td <- bindtextdomain(domain = "woc", dirname = file.path(Sys.getenv("TRAVIS_BUILD_DIR"), "translations"))
} else {
  td <- bindtextdomain(domain = "woc", dirname = file.path(".", "translations"))
}
message(paste("The text domain was set to", td))

#######################
# Requirements & Setup
##
if (!require("pacman")) install.packages("pacman"); library(pacman)
invisible(p_load("dplyr", "xml2"))

os <- Sys.info()["sysname"]

woc.decks <- read_xml("./data/woc.xml")

deck.families.meta <- read.csv(file="./data/deck.families.meta.csv", stringsAsFactors = FALSE)
rituals.meta <- read.csv(file="./data/rituals.meta.csv", stringsAsFactors = FALSE)
darkbonds.meta <- read.csv(file="./data/darkbonds.meta.csv", stringsAsFactors = FALSE)
cards.meta <- read.csv(file="./data/cards.meta.csv", stringsAsFactors = FALSE, colClasses = c("character", "character"))

picture.placeholder <- "picture.placeholder.png"
ritual.placeholder <- "icon.blank.png"

source("./R/deck.parsing.R")

####################
# Data Preparation
##

if(os %in% c("Linux", "Darwin", "Solaris")) {
  Sys.setlocale("LC_ALL", "en_US.UTF-8")
  } else {
  Sys.setlocale("LC_ALL", "English")
  }
Sys.setenv(LANG = "en_US.UTF-8")
players.deck.en <- deck.parsing(woc.decks, domain = "woc")

if(os %in% c("Linux", "Darwin", "Solaris")) {
  Sys.setlocale("LC_ALL", "it_IT.UTF-8")
} else {
  Sys.setlocale("LC_ALL", "Italian")
}
Sys.setenv(LANG = "it_IT.UTF-8")
players.deck.it <- deck.parsing(woc.decks, domain = "woc")

####################
# Deck Flattening
###

# NOTE:
# In this card layout we put darkbond and ritual type at the same position

standard.deck.en <- players.deck.en %>% 
  left_join(deck.families.meta) %>%
  left_join(cards.meta) %>%
  left_join(rituals.meta) %>%
  left_join(darkbonds.meta) %>%
  mutate(picture = ifelse(is.na(picture), picture.placeholder, picture)) %>%
  mutate(ritual.icon = ifelse(is.na(ritual.icon), ifelse(is.na(darkbond.icon), ritual.placeholder, darkbond.icon), ritual.icon)) %>%
  select(card, card.id, family, background, title, description, type, caption, knowledge.points, ritual.icon, picture, ritual.description )
write.csv(standard.deck.en, file = "./data/woc.deck.en.csv", row.names = FALSE, na = "")

message("English Deck Head:\n")
print(standard.deck.en[1:5,c(2,3,5,8)])

standard.deck.it <- players.deck.it %>% 
  left_join(deck.families.meta) %>%
  left_join(cards.meta) %>%
  left_join(rituals.meta) %>%
  left_join(darkbonds.meta) %>%
  mutate(picture = ifelse(is.na(picture), picture.placeholder, picture)) %>%
  mutate(ritual.icon = ifelse(is.na(ritual.icon), ifelse(is.na(darkbond.icon), ritual.placeholder, darkbond.icon), ritual.icon)) %>%
  select(card, card.id, family, background, title, description, type, caption, knowledge.points, ritual.icon, picture, ritual.description )
write.csv(standard.deck.it, file = "./data/woc.deck.it.csv", row.names = FALSE, na = "")

message("Italian Deck Head:\n")
print(standard.deck.it[1:5,c(2,3,5,8)])
