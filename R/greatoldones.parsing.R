greatoldones.parsing <- function(deck, domain = NULL){
  
  do.call(plyr::rbind.fill, xml_find_all(deck, "/deck/card") %>%
            lapply(function(x){
              
              ### CARD
              card <- 1
              if(xml_has_attr(x, "n")) card <- xml_attr(x, "n")
              
              ### CARD ID
              card.id <- ""
              if(xml_has_attr(x, "id")) card.id <- xml_attr(x, "id")
              
              ### TITLE
              title <- ""
              if(class((xml_find_first(x, ".//title"))) != "xml_missing"){
                t <- xml_find_first(x, ".//title")
                title <- do.call(gettextf, c(list(xml_text(xml_find_first(t, ".//label"))), lapply(xml_find_all(t, ".//arg"), function(arg){
                  if(xml_has_attr(arg, "unit")) return(sprintf("%s %s", xml_text(arg), gettext(xml_attr(arg, "unit"), domain = domain)))
                  return(gettext(xml_text(arg), domain = domain))
                }), domain = domain))
              }
              
              message(paste("Adding card:", title))
              
              ### DARK BOND
              darkbond.type <- ""
              if(class((xml_find_first(x, ".//darkbond"))) != "xml_missing"){
                darkbond.type <- xml_attr(xml_find_first(x, ".//darkbond"), "type")
              }
              
              ### RITUALS
              ritual.captions <- data.frame()
              ritual.descriptions <- data.frame()
              
              if(class((xml_find_first(x, ".//ritual"))) != "xml_missing"){
                
                t <- xml_find_first(x, ".//ritual")
                
                ritual.ids <- do.call(rbind, lapply(xml_find_all(t, ".//phase"), function(phase){
                  if(xml_has_attr(phase, "id")) return((xml_attr(phase, "id")))
                  return("")
                }))
                
                ### RITUAL CAPTION
                ritual.captions <- do.call(rbind, lapply(xml_find_all(t, ".//phase"), function(phase){do.call(gettextf, c(list(xml_text(xml_find_first(phase, ".//caption/label"))), lapply(xml_find_all(phase, ".//arg"), function(arg){
                  if(xml_has_attr(arg, "unit")) return(sprintf("%s %s", xml_text(arg), gettext(xml_attr(arg, "unit"), domain = domain)))
                  return(gettext(xml_text(arg), domain = domain))
                }), domain = domain))}))
                
                ritual.captions <- as.data.frame(ritual.captions) %>% mutate(icon.id = paste("ritual.caption", ritual.ids, sep = "."))
                ritual.captions <- ritual.captions %>% spread(icon.id, V1)
                
                ### RITUAL TYPES
                ritual.types <- do.call(rbind, lapply(xml_find_all(t, ".//phase"), function(phase){do.call(gettextf, c(list(xml_text(xml_find_first(phase, ".//type"))), lapply(xml_find_all(phase, ".//arg"), function(arg){
                  if(xml_has_attr(arg, "unit")) return(sprintf("%s %s", xml_text(arg), gettext(xml_attr(arg, "unit"), domain = domain)))
                  return(gettext(xml_text(arg), domain = domain))
                }), domain = domain))}))
                
                ritual.types <- as.data.frame(ritual.types) %>% mutate(icon.id = paste("ritual.types", ritual.ids, sep = "."))
                ritual.types <- ritual.types %>% spread(icon.id, V1)
                
                

                ### RITUAL DESCRIPTION
                ritual.descriptions <- do.call(rbind, lapply(xml_find_all(t, ".//phase"), function(phase){do.call(gettextf, c(list(xml_text(xml_find_first(phase, ".//description/label"))), lapply(xml_find_all(phase, ".//arg"), function(arg){
                  if(xml_has_attr(arg, "unit")) return(sprintf("%s %s", xml_text(arg), gettext(xml_attr(arg, "unit"), domain = domain)))
                  return(gettext(xml_text(arg), domain = domain))
                }), domain = domain))}))
               
                ritual.descriptions <- as.data.frame(ritual.descriptions) %>% mutate(icon.id = paste("ritual.description", ritual.ids, sep = "."))
                ritual.descriptions <- ritual.descriptions %>% spread(icon.id, V1)
                
              }
              
              if(nrow(ritual.captions)>0) return(data.frame(card, card.id, title, darkbond.type, ritual.types, ritual.captions, ritual.descriptions, stringsAsFactors = FALSE))
              else return(data.frame(card, card.id, title, darkbond.type, stringsAsFactors = FALSE))
              
            })
          
  )
}