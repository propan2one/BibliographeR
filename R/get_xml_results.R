library(rentrez)
library(tidyverse)

get_ids <- function(query, retmax = 1000){
  query_search <- entrez_search(db = "pubmed", term = query, retmode = "xml" , retmax = retmax)
  query_search$ids
}

get_xml <- function(ids){
  entrez_fetch(db = "pubmed", id = ids, rettype = "xml")
}

get_from_xml <- function(xml, what = "title"){
  parse_pubmed_xml(xml) %>%
    map(what)
}

list_var <- c("title", "authors", "year", "journal", "volume", "issue", "pages", "key_words", "doi", "pmid", "abstract")
list_var <- c("title", "authors", "year", "journal", "volume", "pages", "key_words", "doi", "pmid", "abstract")

list_var2 <- c("title", "year", "journal", "volume", "issue", "pmid", "abstract")

get_from_xml(xml, "doi") %>% str_replace_all("NULL", "NA")

list_var %>%
  map(~get_from_xml(xml, .x))

make_df <- function(query, xml, var){
  tib <- tibble(id = get_ids(query), var = get_from_xml(xml, var)) %>% na_if("NULL") %>% unnest()
  #tib$var <- str_replace_all(tib$var, "NULL", "NA") 
  names(tib) <- c("id", var)
  tib
}

test <- make_df(query = query , xml = xml, var = "key_words")

test <- list_var %>%
  map_dfc(~make_df(query, xml, .x))

names(test) <- list_var


test <- test %>%
  unnest()





test$title %>% flatten_chr()

test$title

test %>%
  map("key_words")

tibble(id = get_ids(query), "authors" = get_from_xml(xml, "authors")) %>%
  unnest()

get_authors <- function(xml){
  parse_pubmed_xml(xml) %>%
    map("authors")
}

query <- "oyster herpesvirus"

ids <- get_ids(query)

xml <- entrez_fetch(db = "pubmed", id = ids, rettype = "xml")

euh_well <- parse_pubmed_xml(xml)

euh_well %>%
  map("title")


query_search$ids
query_search$retmax
query_search$file
query_search$QueryTranslation
query_search$count

