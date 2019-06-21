library(readr)

path = "scimago_data/"
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

