# tokenize text at the single word (aka unigram) level
ll <- tab$keywords %>%
  map(str_split, ";") %>%
  flatten()

sub_tab_id_kw <- tibble(pmid = tab$pmid, year = tab$year, keyword = ll) %>%
  unnest() %>%
  mutate(keyword = keyword %>% 
           str_squish() %>%
           str_to_lower()
           ) %>%
  filter(!is.na(keyword))

count_word <- sub_tab_id_kw %>%
  count(keyword, sort = TRUE)


avg_year <- sub_tab_id_kw %>%
  group_by(keyword) %>%
  summarise(avg_year = mean(as.numeric(year), na.rm = TRUE))
  
tab_count_year <- avg_year %>%
  left_join(count_word)
library(ggplot2)
library(ggrepel)

# select the top 100 words by n (aka word count)
tab_count_year %>% top_n(40, wt = n) %>%



# construct ggplot
ggplot(aes(avg_year, n, label = keyword)) +

# ggrepel geom, make arrows transparent, color by rank, size by n
geom_text_repel(segment.alpha = 0,
                aes(colour = avg_year, size = n)) +

# set color gradient,log transform & customize legend
scale_color_gradient(
  low = "green3",
  high = "violetred",
  trans = "log10",
  guide = guide_colourbar(direction = "horizontal",
                          title.position = "top")
) +
# set word size range & turn off legend
scale_size_continuous(range = c(3, 10),
                      guide = FALSE) +
scale_x_log10() +     # use log-scale for x-axis
ggtitle(
  paste0(
    "Top 20 words from ",
    nrow(sub_tab_id_kw),
    # dynamically include row count
    " Hacker News article comments, by frequency"
  ),
  subtitle = "word frequency (size) ~ year (color)"
) +
labs(y = "Word frequency", x = "Year") +

# minimal theme & customizations
theme_minimal() +
theme(
  legend.position = c(.99, .99),
  legend.justification = c("right", "top"),
  panel.grid.major = element_line(colour = "whitesmoke")
)


hn_word_tokens <- tab %>% unnest_tokens(word, input = keywords)

# remove stop words (e.g. 'a', 'the', 'and')
hn_word_tokens_no_stop <- hn_word_tokens %>% anti_join(get_stopwords())

# create word counts
hn_word_counts <- hn_word_tokens_no_stop %>% count(word, sort = T)

# print top 10 most frequent words
hn_word_counts %>% head(10)