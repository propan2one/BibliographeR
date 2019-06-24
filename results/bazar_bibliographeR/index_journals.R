index_df <- readRDS("~/git/BibliographeR/results/bazar_bibliographeR/index_df.RDS")

index_df <- index_df %>%
  mutate(journal = journal %>%
           str_replace_all("&", "AND") %>%
           str_squish() %>%
           str_to_upper())

glimpse(index_df)

tab <- readRDS("~/git/BibliographeR/results/bazar_bibliographeR/tab_oyster_author_coord.RDS")

tab <- tab %>%
  mutate(journal = journal %>%
           str_to_upper() %>%
           str_squish() %>%
           str_replace_all("&AMP;", "AND") )

glimpse(tab)

names(tab)
names(index_df)

tab_complet <- tab %>%
  left_join(index_df)

tab_complet %>%
  filter(!is.na(SJR)) %>%
  glimpse()

tab_complet %>%
  count(pmid, sort = TRUE) %>%
  filter(n>1) %>%
  select(pmid) %>%
  pull()-> list_id

tab_complet %>%
  filter(pmid %in% list_id)

complete_table_index <- readRDS("~/git/BibliographeR/results/bazar_bibliographeR/complete_table_index.RDS")

glimpse(complete_table_index)

install.packages("CGPfunctions")
library(CGPfunctions)
newggslopegraph(newcancer, Year, Survival, Type)
glimpse(newcancer)


complete_table_index %>%
  filter(year == "2017") %>%
  select(journal, Total_Docs, SJR, `H index`, `Journal Impact Factor`, `Eigenfactor Score`) %>%
  distinct() %>%
  filter(!is.na(`Eigenfactor Score`)) %>%
  mutate(journal = str_to_upper(journal)) %>%
  mutate_if(is.numeric, rank) %>%
  gather(key = "index", value = "value", -journal) %>%
  newggslopegraph( index, value, journal, Title = "Journals ranks", SubTitle = "with different indexes",
                   Caption = "", WiderLabels = TRUE)

