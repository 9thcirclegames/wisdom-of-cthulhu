#!/usr/bin/env Rscript
execution.start.time <- Sys.time()
td <- NULL
if(nchar(Sys.getenv("BUILD_DIR"))>0){
  setwd(Sys.getenv("BUILD_DIR"))
  td <- bindtextdomain(domain = "woc", dirname = file.path(Sys.getenv("BUILD_DIR"), "translations"))
} else {
  td <- bindtextdomain(domain = "woc", dirname = file.path(".", "translations"))
}
message(paste("The text domain was set to", td))

lang <- Sys.getenv("WOC_DECK_LOCALE")
if(nchar(lang)==0) lang <- "en"

message(paste("Rendering locale:", lang))

#######################
# Requirements & Setup
##
if (!require("pacman")) install.packages("pacman"); invisible(library(pacman))
invisible(p_load("dplyr", "xml2", "tidyr"))

os <- Sys.info()["sysname"]

woc.decks <- read_xml("./data/woc.xml")
#greatoldones.decks <- read_xml("./data/woc.greatoldones.xml")

deck.families.meta <- read.csv(file="./data/deck.families.meta.csv", stringsAsFactors = FALSE)
rituals.meta <- read.csv(file="./data/rituals.meta.csv", stringsAsFactors = FALSE)
darkbonds.meta <- read.csv(file="./data/darkbonds.meta.csv", stringsAsFactors = FALSE)
cards.meta <- read.csv(file="./data/cards.meta.csv", stringsAsFactors = FALSE, colClasses = c("character", "character"))
types.meta <- read.csv(file="./data/types.meta.csv", stringsAsFactors = FALSE)


picture.placeholder <- "picture.placeholder.png"
ritual.placeholder <- "icon.blank.png"
darkbond.placeholder <- "icon.blank.png"

source("./R/deck.parsing.R")
source("./R/greatoldones.parsing.R")

# TODO Add better internationalization support
switch(lang,
       en={
         language="English"
         charset="en_US.UTF-8"
       },
       it={
         language="Italian"
         charset="it_IT.UTF-8"
       }
)

####################
# Data Preparation
##

message(paste("Setting locale to", if(os %in% c("Linux", "Darwin", "Solaris")) {
  Sys.setlocale("LC_ALL", charset)
  Sys.setlocale("LC_MESSAGES", charset)
  Sys.getlocale()
  } else {
  Sys.setlocale("LC_ALL", language)
  }))
Sys.setenv(LANG = charset)

players.deck <- deck.parsing(woc.decks, domain = "woc")
greatoldones.deck <- deck.parsing(greatoldones.deck, domain = "woc")

####################
# Deck Flattening
###

affected.columns.idx <- which(grepl("ritual\\.(study|transmutation|sacrifice).*", colnames(players.deck), perl = TRUE))
affected.columns.names <- colnames(players.deck)[affected.columns.idx]

ritual.sub <- as.data.frame(do.call(cbind, lapply(affected.columns.idx, function(i, deck){
  d <- gsub("FW Imm", "icon.forbidden-wisdom-immediate.png", deck[,i])
  d <- gsub("FW", "icon.forbidden-wisdom.png", d)
  d <- gsub("DM", "icon.dark-master.png", d)
  d <- gsub("EN", "icon.entity.png", d)
  d <- gsub("AS", "icon.alien-science.png", d)
  d <- gsub("Place", "icon.arcane-place.png", d)
  d <- gsub("NULL", "icon.blank.png", d)
  d <- gsub("Res", "icon.research.png", d)
  d <- gsub("Obs", "icon.obsession.png", d)
  return(d)
}, deck = players.deck)), stringsAsFactors = FALSE)
colnames(ritual.sub) <- affected.columns.names

standard.deck <- players.deck %>%
  left_join((deck.families.meta %>% select(family, background)), by = "family") %>%
  left_join(cards.meta, by = "card.id") %>%
  left_join(rituals.meta, by = "ritual.type") %>%
  left_join(darkbonds.meta, by = "darkbond.type") %>%
  left_join(types.meta, by = "type") %>%
  mutate(family.icon = gsub("background.", "icon.", background)) %>%
  mutate("*.back?" = "n") %>%
  mutate(picture = ifelse(is.na(picture), picture.placeholder, picture)) %>%
  mutate(ritual.icon = ifelse(is.na(ritual.icon), ifelse(is.na(darkbond.icon), ritual.placeholder, darkbond.icon), ritual.icon)) %>%
  #mutate(darkbond.icon = ifelse(is.na(darkbond.icon), darkbond.placeholder, darkbond.icon)) %>%
  mutate("ritual.study.trans.slash?" = ifelse(nchar(ritual.type)>0, "Y", "")) %>%
  mutate("ritual.trans.sacrifice.slash?" = ifelse(nchar(ritual.type)>0, "Y", "")) %>%
  select("card>" = card, card.id, type.icon, family, background, caption, family.icon, title, description, type, caption, knowledge.points, ritual.icon, darkbond.icon, picture, ends_with("?")) %>%
  cbind(ritual.sub) %>%
  mutate(BACK = "BACK") %>%
  mutate("*.front?" = "n") %>%
  left_join((deck.families.meta %>% select(family, background.back, family.back)), by = "family")

deck.file <- paste("./build/woc.deck", lang, "csv", sep=".")

write.csv(standard.deck, file = deck.file, row.names = FALSE, na = "")
