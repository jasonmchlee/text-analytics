library(textreadr)
library(tidytext)
library(stopwords)
library(dplyr)
library(tidyverse)
library(tidytext)
library(stringr)
library(ggplot2)
library(tidyr)
library(scales)
library(readr)
library(reshape2)
library(wordcloud)
library(igraph)
library(ggraph)


######################################################################################################
################################## TXT FILE FORMAT AS GROUP ##########################################

setwd("C:/Users/jason/Dropbox/Hult Business School/Module B/Text Mining/Business Insights Report/txt")
nm <- list.files(path="C:/Users/jason/Dropbox/Hult Business School/Module B/Text Mining/Business Insights Report/txt")

#using read document to import the data:
my_data <- read_document(file=nm[1]) #This comes out as a vector
my_data_together <- paste(my_data, collapse = " ") # This will give us a concatenated vector


#merge texts files into on and apply function to make it structured
my_txt_text <- do.call(rbind, lapply(nm, function(x) paste(read_document(file=x), collapse = " ")))


my_txt_text <- as.data.frame(my_txt_text)
colnames(my_txt_text) <- c("text")
class(my_txt_text$text)

my_txt_text <- data.frame(lapply(my_txt_text, as.character), stringsAsFactors=FALSE)

  
tidy_txt <- my_txt_text %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)  %>%
  anti_join(cust_stop) %>%
  count(word, sort = T)



#########################################################################################
################################## READ FILES INDIVIDUALLY ##############################

apple <- read_document(file="C:/Users/jason/Dropbox/Hult Business School/Module B/Text Mining/Business Insights Report/txt/apple.txt")
google <- read_document(file="C:/Users/jason/Dropbox/Hult Business School/Module B/Text Mining/Business Insights Report/txt/google.txt")
microsoft <- read_document(file="C:/Users/jason/Dropbox/Hult Business School/Module B/Text Mining/Business Insights Report/txt/microsoft.txt")
twitter <- read_document(file="C:/Users/jason/Dropbox/Hult Business School/Module B/Text Mining/Business Insights Report/txt/twitter.txt")
facebook <- read_document(file="C:/Users/jason/Dropbox/Hult Business School/Module B/Text Mining/Business Insights Report/txt/facebook.txt")





########## SET UP DATAFRAME APPLE ##########
ap <- as.data.frame(apple)
colnames(ap) <- c("text") #rename column to text
ap_df <- data.frame(lapply(ap, as.character), stringsAsFactors=FALSE) #convert column type to character

########## SET UP DATAFRAME GOOGLE ##########
gg <- as.data.frame(google)
colnames(gg) <- c("text")
gg_df <- data.frame(lapply(gg, as.character), stringsAsFactors=FALSE)


########## SET UP DATAFRAME MICROSOFT ##########
mc <- as.data.frame(microsoft)
colnames(mc) <- c("text")
mc_df <- data.frame(lapply(mc, as.character), stringsAsFactors=FALSE)


########## SET UP DATAFRAME TWITTER ##########
tw <- as.data.frame(twitter)
colnames(tw) <- c("text")
tw_df <- data.frame(lapply(tw, as.character), stringsAsFactors=FALSE)


########## SET UP DATAFRAME FACEBOOK ##########
fb <- as.data.frame(facebook)
colnames(fb) <- c("text")
fb_df <- data.frame(lapply(fb, as.character), stringsAsFactors=FALSE)



###################################################################
###################### CREATE STOP WORDS ##########################
cust_stop <- data_frame(
  word = c("page", "2018", "2019", "â", "apple", "google", "microsoft", "weâ", "twitter", "facebook"), #words we want to remove
  lexicon = rep("custom", each = 10)
)

####################################################################
######################### COUNT FREQUENCY ##########################

tidy_ap <- ap_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop) %>%
  count(word, sort = T)


tidy_gg <- gg_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop) %>%
  count(word, sort = T)

tidy_mc <- mc_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop) %>%
  count(word, sort = T)


tidy_tw <- tw_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop) %>%
  count(word, sort = T)

tidy_fb <- fb_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop) %>%
  count(word, sort = T)


###################################################################
######################### PLOT FREQUENCY ##########################
###################################################################

#### Apple PLOT ######
tidy_ap <- ap_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop)

tidy_ap %>%
  count(word, sort=TRUE) %>%
  filter(n > 100) %>%
  mutate(word = reorder(word,n )) %>%
  ggplot(aes(word, n))+
  geom_col(fill= 'blue')+
  labs(y="Word Count", x=NULL, title = "Apple")+
  coord_flip()


##### GOOGLE PLOT #######
tidy_gg <- gg_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop)

tidy_gg %>%
  count(word, sort=TRUE) %>%
  filter(n > 60) %>%
  mutate(word = reorder(word,n )) %>%
  ggplot(aes(word, n))+
  geom_col(fill= 'red')+
  labs(y="Word Count", x=NULL, title = "Google")+
  coord_flip()


##### Microsoft PLOT #######
tidy_mc <- mc_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop)

tidy_mc %>%
  count(word, sort=TRUE) %>%
  filter(n > 30) %>%
  mutate(word = reorder(word,n )) %>%
  ggplot(aes(word, n))+
  geom_col(fill= 'lightgreen')+
  labs(y="Word Count", x=NULL, title = "Microsoft")+
  coord_flip()


###############################################################################
################## CHECK SENTIMENT VALUE FOR AFINN LIBRARY ####################
###############################################################################

afinn_ap <- ap_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop)%>%
  inner_join(get_sentiments("afinn")) %>%
  summarise(mean(value))


affin_gg <- gg_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop) %>%
  inner_join(get_sentiments("afinn")) %>%
  summarise(mean(value))

affin_mc <- mc_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop) %>%
  inner_join(get_sentiments("afinn")) %>%
  summarise(mean(value))


##############################################################################
################## CHECK SENTIMENT VALUE FOR BING LIBRARY ####################
##############################################################################

bing_ap <- ap_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop)%>%
  inner_join(get_sentiments("bing")) %>%
  count(sentiment)


bing_gg <- gg_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop) %>%
  inner_join(get_sentiments("bing")) %>%
  count(sentiment)

bing_mc <- mc_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop) %>%
  inner_join(get_sentiments("bing")) %>%
  count(sentiment)



#############################################################################
################## CHECK SENTIMENT VALUE FOR NRC LIBRARY ####################
#############################################################################

nrc_ap <- ap_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop)%>%
  inner_join(get_sentiments("nrc")) %>%
  count(sentiment)


nrc_gg <- gg_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop) %>%
  inner_join(get_sentiments("nrc")) %>%
  count(sentiment)

nrc_mc <- mc_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(cust_stop) %>%
  inner_join(get_sentiments("nrc")) %>%
  count(sentiment)



#################################################################################
####################### ALL DATAFRAMES SENTIMENT GRAPHS #########################
######### CHANGE THE DATAFRAM TYPE TO GET GRAPHS OF DIFFERENT FILES #############
#################################################################################

# BING
bing_text <- my_txt_text %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort=T) %>%
  ungroup()

# BING GRAPH
bing_text %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word=reorder(word, n)) %>%
  ggplot(aes(word, n, fill=sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y")+
  labs(y="Contribution to sentiment", x=NULL, title = "Combined Dataframes")+
  coord_flip()

# BING WORDCLOUD
bing_text %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort=TRUE) %>%
  acast(word ~sentiment, value.var="n", fill=0) %>%
  comparison.cloud(colors = c("grey20", "gray80"),
                   max.words=100, 
                   scale = c(0.5,0.5),
                   fixed.asp = TRUE,
                   title.size = 1)

# NRC WORDCLOUD
nrc_text <- my_txt_text %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("nrc")) %>%
  count(word, sentiment, sort=T) %>%
  ungroup()

nrc_text %>%
  inner_join(get_sentiments("nrc")) %>%
  count(word, sentiment, sort=TRUE) %>%
  acast(word ~sentiment, value.var="n", fill=0) %>%
  comparison.cloud(colors = c("grey20", "gray80"),
                   max.words=100, 
                   scale = c(0.5,0.5),
                   fixed.asp = TRUE,
                   title.size = 1)

# AFINN BAR CHART
afinn_text <- my_txt_text %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("afinn")) %>%
  count(word, value, sort=T) %>%
  ungroup()

afinn_text %>%
  group_by(value) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word=reorder(word, n)) %>%
  ggplot(aes(word, n, fill=value)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~value, scales = "free_y")+
  labs(y="Contribution to sentiment", x=NULL)+
  coord_flip()



############################################################################
#################### APPLE GRAPHS - SENTIMENT #############################  
############################################################################

# BING
bing_ap <-ap_df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort=T) %>%
  ungroup()

# BING GRAPH
bing_ap %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word=reorder(word, n)) %>%
  ggplot(aes(word, n, fill=sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y")+
  labs(y="Contribution to sentiment", x=NULL, title = "Apple - Bing Sentiments")+
  coord_flip()

# BING WORDCLOUD
bing_ap %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort=TRUE) %>%
  acast(word ~sentiment, value.var="n", fill=0) %>%
  comparison.cloud(colors = c("grey20", "gray80"),
                   max.words=100, 
                   scale = c(0.5,0.5),
                   fixed.asp = TRUE,
                   title.size = 1)

# NRC WORDCLOUD
nrc_ap <-ap_df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("nrc")) %>%
  count(word, sentiment, sort=T) %>%
  ungroup()

nrc_ap %>%
  inner_join(get_sentiments("nrc")) %>%
  count(word, sentiment, sort=TRUE) %>%
  acast(word ~sentiment, value.var="n", fill=0) %>%
  comparison.cloud(colors = c("grey20", "gray80"),
                   max.words=100, 
                   scale = c(0.5,0.5),
                   fixed.asp = TRUE,
                   title.size = 1)

# AFINN BAR CHART
afinn_ap <-ap_df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("afinn")) %>%
  count(word, value, sort=T) %>%
  ungroup()

afinn_ap %>%
  group_by(value) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word=reorder(word, n)) %>%
  ggplot(aes(word, n, fill=value)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~value, scales = "free_y")+
  labs(y="Contribution to sentiment", x=NULL, title = "Apple - NRC Sentiment")+
  coord_flip()

afinn_ap %>%
  inner_join(get_sentiments("afinn")) %>%
  count(word, value, sort=TRUE) %>%
  acast(word ~value, value.var="n", fill=0) %>%
  comparison.cloud(colors = c("grey20", "gray80"),
                   max.words=100, 
                   scale = c(0.5,0.5),
                   fixed.asp = TRUE,
                   title.size = 1)

############################################################################
#################### GOOGLE GRAPHS - SENTIMENT #############################  
############################################################################

# BING
bing_gg <-gg_df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort=T) %>%
  ungroup()

# BING GRAPH
bing_gg %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word=reorder(word, n)) %>%
  ggplot(aes(word, n, fill=sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y")+
  labs(y="Contribution to sentiment", x=NULL, title = "Google - Bing Sentiments")+
  coord_flip()

# BING WORDCLOUD
bing_gg %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort=TRUE) %>%
  acast(word ~sentiment, value.var="n", fill=0) %>%
  comparison.cloud(colors = c("grey20", "gray80"),
                   max.words=100, 
                   scale = c(0.5,0.5),
                   fixed.asp = TRUE,
                   title.size = 1)

# NRC WORDCLOUD
nrc_gg <-gg_df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("nrc")) %>%
  count(word, sentiment, sort=T) %>%
  ungroup()

nrc_gg %>%
  inner_join(get_sentiments("nrc")) %>%
  count(word, sentiment, sort=TRUE) %>%
  acast(word ~sentiment, value.var="n", fill=0) %>%
  comparison.cloud(colors = c("grey20", "gray80"),
                   max.words=100, 
                   scale = c(0.5,0.5),
                   fixed.asp = TRUE,
                   title.size = 1)

# AFINN BAR CHART
afinn_gg <-gg_df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("afinn")) %>%
  count(word, value, sort=T) %>%
  ungroup()

afinn_gg %>%
  group_by(value) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word=reorder(word, n)) %>%
  ggplot(aes(word, n, fill=value)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~value, scales = "free_y")+
  labs(y="Contribution to sentiment", x=NULL, title = "Google - NRC Sentiment")+
  coord_flip()

afinn_gg %>%
  inner_join(get_sentiments("afinn")) %>%
  count(word, value, sort=TRUE) %>%
  acast(word ~value, value.var="n", fill=0) %>%
  comparison.cloud(colors = c("grey20", "gray80"),
                   max.words=100, 
                   scale = c(0.5,0.5),
                   fixed.asp = TRUE,
                   title.size = 1)


############################################################################
################# MICROSOFT GRAPHS - SENTIMENT #############################  
############################################################################

# BING
bing_mc <-mc_df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort=T) %>%
  ungroup()

# BING GRAPH
bing_mc %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word=reorder(word, n)) %>%
  ggplot(aes(word, n, fill=sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y")+
  labs(y="Contribution to sentiment", x=NULL, title = "Microsoft - Bing Sentiments")+
  coord_flip()

# BING WORDCLOUD
bing_mc %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort=TRUE) %>%
  acast(word ~sentiment, value.var="n", fill=0) %>%
  comparison.cloud(colors = c("grey20", "gray80"),
                   max.words=100, 
                   scale = c(0.5,0.5),
                   fixed.asp = TRUE,
                   title.size = 1)

# NRC WORDCLOUD
nrc_mc <-mc_df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("nrc")) %>%
  count(word, sentiment, sort=T) %>%
  ungroup()

nrc_mc %>%
  inner_join(get_sentiments("nrc")) %>%
  count(word, sentiment, sort=TRUE) %>%
  acast(word ~sentiment, value.var="n", fill=0) %>%
  comparison.cloud(colors = c("grey20", "gray80"),
                   max.words=100, 
                   scale = c(0.5,0.5),
                   fixed.asp = TRUE,
                   title.size = 1)

# AFINN BAR CHART
afinn_mc <- mc_df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("afinn")) %>%
  count(word, value, sort=T) %>%
  ungroup()

afinn_mc %>%
  group_by(value) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word=reorder(word, n)) %>%
  ggplot(aes(word, n, fill=value)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~value, scales = "free_y")+
  labs(y="Contribution to sentiment", x=NULL, title = "Google - NRC Sentiment")+
  coord_flip()

afinn_mc %>%
  inner_join(get_sentiments("afinn")) %>%
  count(word, value, sort=TRUE) %>%
  acast(word ~value, value.var="n", fill=0) %>%
  comparison.cloud(colors = c("grey20", "gray80"),
                   max.words=100, 
                   scale = c(0.5,0.5),
                   fixed.asp = TRUE,
                   title.size = 1)

############################################################################
################# FACEBOOK GRAPHS - SENTIMENT #############################  
############################################################################

# BING
bing_fb <-fb_df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort=T) %>%
  ungroup()

# BING GRAPH
bing_fb %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word=reorder(word, n)) %>%
  ggplot(aes(word, n, fill=sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y")+
  labs(y="Contribution to sentiment", x=NULL, title = "Microsoft - Bing Sentiments")+
  coord_flip()

# BING WORDCLOUD
bing_fb %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort=TRUE) %>%
  acast(word ~sentiment, value.var="n", fill=0) %>%
  comparison.cloud(colors = c("grey20", "gray80"),
                   max.words=100, 
                   scale = c(0.5,0.5),
                   fixed.asp = TRUE,
                   title.size = 1)

# NRC WORDCLOUD
nrc_fb <-fb_df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("nrc")) %>%
  count(word, sentiment, sort=T) %>%
  ungroup()

nrc_fb %>%
  inner_join(get_sentiments("nrc")) %>%
  count(word, sentiment, sort=TRUE) %>%
  acast(word ~sentiment, value.var="n", fill=0) %>%
  comparison.cloud(colors = c("grey20", "gray80"),
                   max.words=100, 
                   scale = c(0.5,0.5),
                   fixed.asp = TRUE,
                   title.size = 1)

# AFINN BAR CHART
afinn_fb <- fb_df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("afinn")) %>%
  count(word, value, sort=T) %>%
  ungroup()

afinn_fb %>%
  group_by(value) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word=reorder(word, n)) %>%
  ggplot(aes(word, n, fill=value)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~value, scales = "free_y")+
  labs(y="Contribution to sentiment", x=NULL, title = "Google - NRC Sentiment")+
  coord_flip()

afinn_fb %>%
  inner_join(get_sentiments("afinn")) %>%
  count(word, value, sort=TRUE) %>%
  acast(word ~value, value.var="n", fill=0) %>%
  comparison.cloud(colors = c("grey20", "gray80"),
                   max.words=100, 
                   scale = c(0.5,0.5),
                   fixed.asp = TRUE,
                   title.size = 1)


##################################################################################
##################### APPLE vs Google and Microsoft ###########################
##################################################################################


frequency <- bind_rows(mutate(tidy_ap, author="Apple"),
                       mutate(tidy_gg, author= "Google"),
                       mutate(tidy_mc, author="Microsoft")
) %>%
  mutate(word=str_extract(word, "[a-z']+")) %>%
  count(author, word) %>%
  group_by(author) %>%
  mutate(proportion = n/sum(n))%>%
  select(-n) %>%
  spread(author, proportion) %>%
  gather(author, proportion, `Google`, `Microsoft`)



###############################################################################
########################## PLOT CORRELOGRAM ###################################

ggplot(frequency, aes(x=proportion, y=`Apple`, 
                      color = abs(`Apple`- proportion)))+
  geom_abline(color="grey40", lty=2)+
  geom_jitter(alpha=.1, size=2.5, width=0.3, height=0.3)+
  geom_text(aes(label=word), check_overlap = TRUE, vjust=1.5) +
  scale_x_log10(labels = percent_format())+
  scale_y_log10(labels= percent_format())+
  scale_color_gradient(limits = c(0,0.001), low = "darkslategray4", high = "gray75")+
  facet_wrap(~author, ncol=2)+
  theme(legend.position = "none")+
  labs(y= "Apple", x=NULL)


cor.test(data=frequency[frequency$author == "Google",],
         ~proportion + `Apple`)

cor.test(data=frequency[frequency$author == "Microsoft",],
         ~proportion + `Apple`)


############################################################################
####################### Apple vs Facebook and Twitter ######################
############################################################################

frequency_2 <- bind_rows(mutate(tidy_ap, author="Apple"),
                       mutate(tidy_fb, author= "Facebook"),
                       mutate(tidy_tw, author="Twitter")
) %>%
  mutate(word=str_extract(word, "[a-z']+")) %>%
  count(author, word) %>%
  group_by(author) %>%
  mutate(proportion = n/sum(n))%>%
  select(-n) %>%
  spread(author, proportion) %>%
  gather(author, proportion, `Facebook`, `Twitter`)



###############################################################################
########################## PLOT CORRELOGRAM AGAINST TWITTER ###################

ggplot(frequency_2, aes(x=proportion, y=`Apple`, 
                      color = abs(`Apple`- proportion)))+
  geom_abline(color="grey40", lty=2)+
  geom_jitter(alpha=.1, size=2.5, width=0.3, height=0.3)+
  geom_text(aes(label=word), check_overlap = TRUE, vjust=1.5) +
  scale_x_log10(labels = percent_format())+
  scale_y_log10(labels= percent_format())+
  scale_color_gradient(limits = c(0,0.001), low = "darkslategray4", high = "gray75")+
  facet_wrap(~author, ncol=2)+
  theme(legend.position = "none")+
  labs(y= "Apple", x=NULL)


cor.test(data=frequency[frequency$author == "Facebook",],
         ~proportion + `Apple`)

cor.test(data=frequency[frequency$author == "Twitter",],
         ~proportion + `Apple`)




###############################################################################
##################### COMBINE ALL TIDY QUESTIONS INTO ONE #####################
###############################################################################

combined_reports <- bind_rows(
  mutate(tidy_ap, location = "one"),
  mutate(tidy_gg, location = "two"),
  mutate(tidy_mc, location = "three"),
)


######## WE ARE MORE INTERESTED IN THE WORDS WHICH ARE LESS FREQUENT ############

combined_reports <- combined_reports %>%
  bind_tf_idf(word,location, n) %>%
  arrange(desc(tf_idf))

# graph
combined_reports %>%
  arrange(desc(tf_idf)) %>%
  mutate(word=factor(word, levels=rev(unique(word)))) %>%
  group_by(location) %>%
  top_n(15) %>%
  ungroup %>%
  ggplot(aes(word, tf_idf, fill=location))+
  geom_col(show.legend=FALSE)+
  labs(x=NULL, y="tf-idf")+
  facet_wrap(~location, ncol=2, scales="free")+
  coord_flip()



#####################################################################
######################## BI GRAMS ###################################
#####################################################################

txt_bigrams <- my_txt_text %>%
  unnest_tokens(bigram, text, token = "ngrams", n=2) %>%
  count(bigram, sort = TRUE)


bigrams_separated <- txt_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

# remove stop words from each variable
bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

#creating the new bigram, "no-stop-words":
bigram_counts <- bigrams_filtered %>%
  count(word1, word2, sort = TRUE)

#want to see the new bigrams
bigram_counts

# united bigrams
bigram_united <- bigrams_filtered %>%
  unite(bigram, word1, word2, sep=" ")

bigram_tf_idf <- bigram_united %>%
  count(location, bigram) %>%
  bind_tf_idf(bigram, location, n) %>%
  arrange(desc(tf_idf))

negation_tokens <- c("no", "not")#what negation tokens do you want to use?

negated_words <- bigrams_separated %>%
  filter(word1 %in% negation_tokens) %>%
  inner_join(get_sentiments("afinn"), by=c(word2="word")) %>%
  count(word1, word2, value, sort=TRUE) %>%
  ungroup()

negated_words


#################################################
####### function to plot the negations ##########
#################################################
negated_words_plot <- function(x){
  negated_words %>%
    filter(word1 == x) %>%
    mutate(contribution = n* value) %>%
    arrange(desc(abs(contribution))) %>%
    head(20) %>%
    mutate(word2 = reorder(word2, contribution)) %>%
    ggplot(aes(word2, n*value, fill = n*value >0))+
    geom_col(show.legend = FALSE)+
    xlab(paste("Words preceded by", x))+
    ylab("Sentiment score* number of occurences")+
    coord_flip()
}#closing the negated_words_plot function

negated_words_plot(x="not") #this is your first negation word
negated_words_plot(x="xxxxxxx") #this is your second negation word
negated_words_plot(x="xxxxxxx") #this is your third negation word

######################################################
####### VISUALISING A BIGRAM NETWORK #################
######################################################
bigram_graph <- bigram_counts %>%
  filter(n>20) %>%
  graph_from_data_frame()

ggraph(bigram_graph, layout = "fr") +
  geom_edge_link()+
  geom_node_point()+
  geom_node_text(aes(label=name), vjust =1, hjust=1)
