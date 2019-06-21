#institution
#install.packages("ggmap")
library(ggmap)
library(tidyverse)

df <- read_csv("authors_per_institution.csv") %>%
  filter(!is.na(institution))

#AIzaSyDojdF3OzfYFo6DcwH6hSobb1eVlX5Plso
#register_google(key = "AIzaSyDojdF3OzfYFo6DcwH6hSobb1eVlX5Plso", write = TRUE)
#key in /home/cecile/.Renviron

df_c <- df %>%
   mutate_geocode(institution)

saveRDS(df_c, "coord_institutions.RDS")


for( i in 1:nrow(df)){
  print(i)
  df_temp <- df[i,] %>%
    mutate_geocode(institution)
  df_c <- df_c %>%
    bind_rows(df_temp)
  saveRDS(df_c, "coord_institutions_loop.RDS")
}


t2 <- coord_institutions_loop_oyster %>%
  filter(!is.na(lat)) %>%
  select(-abstract)

tab <- df %>%
  left_join(t2)

tab %>%
  count(year, sort = TRUE) %>%
  arrange(year) %>%
  mutate(nb_paper = cumsum(n),
         year = as.numeric(year)) %>%
  ggplot(aes(x = year, y = nb_paper )) +
  geom_line() +
  geom_point()

tab %>%
  saveRDS("tab_oyster_author_coord.RDS")
