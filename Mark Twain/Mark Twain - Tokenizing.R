install.packages("gutenbergr")

library(gutenbergr)
library(tidytext)
library(dplyr)
data(stop_words)

# Mark Twain
# Adventures of Huckleberry Finn
# The Adventures of Tom Sawyer
# The Innocents Abroad 
# Life on the Mississippi

mark_twain <- gutenberg_download(c(76, 74, 3176, 245))


# remove stop words
tidy_mark_twain <- mark_twain %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)
print(tidy_mark_twain)


#counting frequencies for tokens
tidy_mark_twain %>%
  count(word, sort=TRUE)


#plotting the token frequencies:
library(ggplot2)
freq_hist <-tidy_mark_twain %>%
  count(word, sort=TRUE) %>%
  filter(n > 400) %>% # we need this to eliminate all the low count words
  mutate(word = reorder(word,n )) %>%
  ggplot(aes(word, n))+
  geom_col(fill= 'lightgreen')+
  xlab(NULL)+
  coord_flip()

print(freq_hist)
