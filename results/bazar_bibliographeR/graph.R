#install.packages("visNetwork")

rm(list = ls())

# Libraries ---------------------------------------------------------------
library(visNetwork)
library(geomnet)
library(igraph)
library(tidyverse)


# Data Preparation --------------------------------------------------------

#Load dataset
data(lesmis)

#Nodes
nodes <- as.data.frame(lesmis[2])
colnames(nodes) <- c("id", "label")

#id has to be the same like from and to columns in edges
nodes$id <- nodes$label

#Edges
edges <- as.data.frame(lesmis[1])
colnames(edges) <- c("from", "to", "width")

#Create graph for Louvain
graph <- graph_from_data_frame(edges, directed = FALSE)

#Louvain Comunity Detection
cluster <- cluster_louvain(graph)

cluster_df <- data.frame(as.list(membership(cluster)))
cluster_df <- as.data.frame(t(cluster_df))
cluster_df$label <- rownames(cluster_df)

#Create group column
nodes <- left_join(nodes, cluster_df, by = "label")
colnames(nodes)[3] <- "group"

p <- visNetwork(nodes, edges)

help("visNetwork")
vignette("Introduction-to-visNetwork")



  