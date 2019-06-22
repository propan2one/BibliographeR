library(readr)

path = "raw/scimago/"
file_list  <- list.files(path = path, recursive = T, full.names = T)

tt <- file_list %>% 
  map(read_delim, ";", escape_double = FALSE, trim_ws = TRUE) %>%
  map_dfr(bind_rows, .id = "ID") %>%
  mutate(ID = as.numeric(ID)) %>%
  mutate(year = ID + 1998) %>%
  select(-ID)

tt %>%
  arrange(Title) %>%
  select(Title) %>%
  distinct() %>%
  head()

tt_gat <- tt %>%
  group_by(year, Sourceid) %>%
  select(contains("Total Docs")) %>%
  select(-contains("years")) %>%
  gather("Year_total_Doc", "Total_Docs", -year, -Sourceid)

tt_gat <- tt_gat %>%
  mutate(Year_total_Doc = Year_total_Doc %>%
           str_extract_all("[:digit:]+"))

tt_gat2 <- tt_gat %>%
  filter(year == Year_total_Doc)

tt_gat2 <- tt_gat2 %>%
  select(-Year_total_Doc)

tt2 <- tt %>%
  select(-c(9,20:38)) %>% 
  left_join(tt_gat2) %>%
  mutate(Title = str_to_upper(Title))

saveRDS(tt2, "raw/scimago.RDS")         

