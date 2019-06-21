#install.packages("fulltext")
library(fulltext)
library(rentrez)
library(tidyverse)
library(XML)
library(roomba)


r_search <- entrez_search(db="pubmed", term="oyster herpesvirus", retmax = 200)

xml <- entrez_fetch(db="pubmed", r_search$ids, rettype = "xml")

xml_list2 <- xmlToList(xml)

list_from <- xml_list2 %>%
  map(c("MedlineCitation", "PMID", "text"))

list_to <- xml_list2 %>%
  map(c("PubmedData", "ReferenceList"),.default = NA) %>%
  map(roomba, "text") %>%
  map("text")


tib <- tibble(from = unlist(list_from), to = list_to)

tib_avec_citation <- tib %>%
  filter(to != "NULL")

tab_graph <- tib_avec_citation %>% unnest()

append(tab_graph$from, values = tab_graph$to) %>%
  unique()

nodes <-tibble(id = append(tab_graph$from, values = tab_graph$to) %>%
                 unique() ) %>%
  mutate(label = id)

edges <- tab_graph

library(igraph)
#Create graph for Louvain
graph <- graph_from_data_frame(edges, directed = FALSE)

#Louvain Comunity Detection
cluster <- cluster_louvain(graph)

cluster_df <- data.frame(as.list(membership(cluster)))
cluster_df <- as.data.frame(t(cluster_df))
rownames(cluster_df) <- rownames(cluster_df) %>%
  str_sub(2) 
cluster_df$label <- rownames(cluster_df)

glimpse(nodes)
glimpse(cluster_df)

#Create group column
nodes <- left_join(nodes, cluster_df)
colnames(nodes)[3] <- "group"

p <- visNetwork(nodes, edges)
p


####################################################################################################

pmid_2010 <- tab %>%
  filter(year <= 2010) %>%
  select(pmid) %>%
  pull()

tab_graph_2010 <- tab_graph %>%
  filter(from %in% pmid_2000)

append(tab_graph$from, values = tab_graph_2010$to) %>%
  unique()

nodes <-tibble(id = append(tab_graph_2010$from, values = tab_graph_2010$to) %>%
                 unique() ) %>%
  mutate(label = id)

edges <- tab_graph_2010

library(igraph)
#Create graph for Louvain
graph <- graph_from_data_frame(edges, directed = FALSE)

#Louvain Comunity Detection
cluster <- cluster_louvain(graph)

cluster_df <- data.frame(as.list(membership(cluster)))
cluster_df <- as.data.frame(t(cluster_df))
rownames(cluster_df) <- rownames(cluster_df) %>%
  str_sub(2) 
cluster_df$label <- rownames(cluster_df)

glimpse(nodes)
glimpse(cluster_df)

#Create group column
nodes <- left_join(nodes, cluster_df)
colnames(nodes)[3] <- "group"

p <- visNetwork(nodes, edges)
p
#####################################################################################################

index_df %>%
  group_by(year) %>%
  count(Title, sort = TRUE)


scimago %>%
  group_by(year) %>%
  count(Title, sort = TRUE)

test <- scimago %>%
  filter(Title == "ACM INTERNATIONAL CONFERENCE PROCEEDING SERIES" & year == "2003")


#########################"
index_df


#install.packages("easyPubMed")
library(easyPubMed)
query <- "oyster AND herpesvirus"
on_pubmed <- get_pubmed_ids(query)
abstracts_xml <- fetch_pubmed_data(on_pubmed, encoding = "ASCII")#, retmax = 4)
df <- table_articles_byAuth(pubmed_data = abstracts_xml, 
                            included_authors = "first", 
                            max_chars = -1,
                            autofill = TRUE)

tt0 <- custom_grep(xml_data= abstracts_xml, tag = 'PubmedArticle', format = "char") 
tt <- custom_grep(xml_data= abstracts_xml, tag = 'ArticleId', format = "char") 
tt %>% str_subset("^[:digit:]{8}")



####
tab$pmid %in% nodes$id %>% cumsum()
## il y a 




class(abstracts_xml) 

#install.packages("XML")
library(XML)
# apply "saveXML" to each //ArticleTitle tag via XML::xpathApply()
my_titles <- unlist(xpathApply(abstracts_xml, "//ArticleTitle", saveXML))

# use gsub to remove the tag, also trim long titles
my_titles <- gsub("(^.{5,10}Title>)|(<\\/.*$)", "", my_titles)
my_titles[nchar(my_titles)>75] <- paste(substr(my_titles[nchar(my_titles)>75], 1, 70), 
                                        "...", sep = "")
print(my_titles)

tt0 %>% custom_grep(tag = 'ArticleId', format = "char")

print(xx[1:5, c("pmid", "lastname", "jabbrv")])

df_c <- df
for(i in 127:nrow(df)){
  print(i)
  df_temp <- df[i,] %>%
    mutate_geocode(address)
  df_c <- df_c %>%
    bind_rows(df_temp)
  saveRDS(df_c, "coord_institutions_loop_oyster.RDS")
}

temp <- df %>%
  left_join(
    df_c %>%
      filter(!is.na(lat)) 
  )


temp[17,]$lon <- 49.156715
temp[17,]$lat <- -123.969696

temp[119,]$lon <- 38.697861
temp[119,]$lat <- -9.230168

temp[115,]$lon <- 38.697861
temp[115,]$lat <- -9.230168

saveRDS(temp, "data_oyster.RDS")

write_file(abstracts_xml, "abstract.xml")
