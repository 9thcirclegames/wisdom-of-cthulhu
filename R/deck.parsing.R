deck.parsing <- function(deck, domain = NULL){

  do.call(rbind,xml_find_all(woc.decks, "/deck/card") %>%
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
              
              ### CAPTION
              caption <- ""
              if(class((xml_find_first(x, ".//caption"))) != "xml_missing"){
                t <- xml_find_first(x, ".//caption")
                caption <- do.call(gettextf, c(list(xml_text(xml_find_first(t, ".//label"))), lapply(xml_find_all(t, ".//arg"), function(arg){
                  if(xml_has_attr(arg, "unit")) return(sprintf("%s %s", xml_text(arg), gettext(xml_attr(arg, "unit"), domain = domain)))
                  return(gettext(xml_text(arg), domain = domain))
                }), domain = domain))
              }
              
              ### COMBINATION
              combination <- ""
              if(class((xml_find_first(x, ".//combination"))) != "xml_missing"){
                t <- xml_find_first(x, ".//combination")
                combination <- do.call(gettextf, c(list(xml_text(xml_find_first(t, ".//label"))), lapply(xml_find_all(t, ".//arg"), function(arg){
                  if(xml_has_attr(arg, "unit")) return(sprintf("%s %s", xml_text(arg), gettext(xml_attr(arg, "unit"), domain = domain)))
                  return(gettext(xml_text(arg), domain = domain))
                }), domain = domain))
              }
              
              ### DESCRIPTION
              description <- ""
              if(class((xml_find_first(x, ".//description"))) != "xml_missing"){
                t <- xml_find_first(x, ".//description")
                description <- do.call(gettextf, c(list(xml_text(xml_find_first(t, ".//label"))), lapply(xml_find_all(t, ".//arg"), function(arg){
                  if(xml_has_attr(arg, "unit")) return(sprintf("%s %s", xml_text(arg), gettext(xml_attr(arg, "unit"), domain = domain)))
                  return(gettext(xml_text(arg), domain = domain))
                }), domain = domain))
              }
              
              ### KP
              knowledge.points <- "?"
              if(class((xml_find_first(x, ".//kp"))) != "xml_missing"){
                knowledge.points <- xml_text(xml_find_first(x, ".//kp"))
              }
              
              ### TYPE
              type <- ""
              if(class((xml_find_first(x, ".//type"))) != "xml_missing"){
                type <- xml_text(xml_find_first(x, ".//type"))
              }
              
              ### FAMILY
              family <- ""
              if(class((xml_find_first(x, ".//family"))) != "xml_missing"){
                family <- xml_text(xml_find_first(x, ".//family"))
              }
              
              ### RITUAL TYPE
              ritual.type <- ""
              if(class((xml_find_first(x, ".//ritual"))) != "xml_missing"){
                ritual.type <- xml_attr(xml_find_first(x, ".//ritual"), "type")
              }
              
              ### DARK BOND
              darkbond.type <- ""
              if(class((xml_find_first(x, ".//darkbond"))) != "xml_missing"){
                darkbond.type <- xml_attr(xml_find_first(x, ".//darkbond"), "type")
              }
              
              ### RITUAL
              ritual <- ""
              if(class((xml_find_first(x, ".//ritual"))) != "xml_missing"){
                t <- xml_find_first(x, ".//ritual")
                ritual <- do.call(paste, lapply(xml_find_all(t, ".//phase"), function(phase){do.call(gettextf, c(list(xml_text(xml_find_first(phase, ".//label"))), lapply(xml_find_all(t, ".//arg"), function(arg){
                  if(xml_has_attr(arg, "unit")) return(sprintf("%s %s", xml_text(arg), gettext(xml_attr(arg, "unit"), domain = domain)))
                  return(gettext(xml_text(arg), domain = domain))
                }), domain = domain))}))
              }
              
              return(data.frame(card, card.id, type, family, title, caption, "description"=trimws(paste(combination, description, collapse=" ")), ritual.description = ritual, ritual.type, darkbond.type, knowledge.points, stringsAsFactors = FALSE))
              
            })
          
  )
}