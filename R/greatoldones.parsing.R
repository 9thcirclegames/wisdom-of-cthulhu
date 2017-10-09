greatoldones.parsing <- function(deck, domain = NULL){
  
  do.call(plyr::rbind.fill, xml_find_all(woc.decks, "/deck/card") %>%
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
              ritual <- ""
              ritual.phases <- data.frame()
              ritual.captions <- data.frame()
              ritual.descriptions <- data.frame()
              
              if(class((xml_find_first(x, ".//ritual"))) != "xml_missing"){
                
                ### RITUAL CAPTION
                t <- xml_find_first(x, ".//ritual")
                ritual.captions <- do.call(rbind, lapply(xml_find_all(t, ".//phase"), function(phase){do.call(gettextf, c(list(xml_text(xml_find_first(phase, ".//caption/label"))), lapply(xml_find_all(phase, ".//arg"), function(arg){
                  if(xml_has_attr(arg, "unit")) return(sprintf("%s %s", xml_text(arg), gettext(xml_attr(arg, "unit"), domain = domain)))
                  return(gettext(xml_text(arg), domain = domain))
                }), domain = domain))}))
                
                
                ### RITUAL PHASES
                t <- xml_find_first(x, ".//ritual")
                ritual.types <- do.call(rbind, lapply(xml_find_all(t, ".//phase"), function(phase){
                  if(xml_has_attr(phase, "id")) return((xml_attr(phase, "id")))
                  return("")
                   }))

                ### RITUAL DESCRIPTION
                t <- xml_find_first(x, ".//ritual")
                ritual.descriptions <- do.call(rbind, lapply(xml_find_all(t, ".//phase"), function(phase){do.call(gettextf, c(list(xml_text(xml_find_first(phase, ".//description/label"))), lapply(xml_find_all(phase, ".//arg"), function(arg){
                  if(xml_has_attr(arg, "unit")) return(sprintf("%s %s", xml_text(arg), gettext(xml_attr(arg, "unit"), domain = domain)))
                  return(gettext(xml_text(arg), domain = domain))
                }), domain = domain))}))
               
                
              }
              
              if(nrow(ritual.icons)>0) return(data.frame(card, card.id, title, darkbond.type, ritual.type, ritual.caption, ritual.description, stringsAsFactors = FALSE))
              else return(data.frame(card, card.id, title, darkbond.type, ritual.type, ritual.caption, ritual.description, stringsAsFactors = FALSE))
              
            })
          
  )
}