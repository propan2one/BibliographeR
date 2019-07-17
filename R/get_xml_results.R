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
list_var2 <- c("title", "year", "journal", "volume", "issue", "pages", "doi", "pmid", "abstract")

get_from_xml(xml, "authors")

list_var %>%
  map(~get_from_xml(xml, .x))

make_df <- function(query, xml, var){
  tibble(id = get_ids(query), var = get_from_xml(xml, var)) 
}

test <- list_var %>%
  map(~make_df(query, xml, .x))

test$var
names(test) <- c("id", list_var)

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

