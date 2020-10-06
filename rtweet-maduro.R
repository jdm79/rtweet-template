## install rtweet from CRAN
install.packages("rtweet")
install.packages("dplyr")
install.packages("usethis")


## load rtweet package
library(rtweet)
library(dplyr)
library(tidyverse)
library(devtools)
devtools::install_github('bbc/bbplot')

if(!require(pacman))install.packages("pacman")

pacman::p_load('dplyr', 'tidyr', 'gapminder',
               'ggplot2',  'ggalt',
               'forcats', 'R.utils', 'png',
               'grid', 'ggpubr', 'scales',
               'bbplot')

# whatever name you assigned to your created app
appname <- ""

## api key (example below is not a real key)
key <- ""

## api secret (example below is not a real key)
secret <- ""

access_token = ""
access_secret = ""

# create token named "twitter_token"
twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret,
  access_token = access_token,
  access_secret = access_secret)

## Returns up to 3,200 statuses posted to the timelines of each of one or more specified Twitter users.
tweets <- get_timeline("NicolasMaduro",
                       "MPPSalud",
                       token = twitter_token,
                       n = 3200
)

july_week <- tweets %>% 
  filter(created_at > "2020-07-18" & created_at <"2020-07-26")

Maduro_df <- july_week  %>%
  select(created_at, screen_name, text)

Maduro_df$created_at <- as.POSIXct(as.Date(Maduro_df$created_at))

Maduro_df$period <- cut.POSIXt(
  Maduro_df$created_at,
  breaks = as.POSIXct(as.Date(c("2020-07-18", "2020-07-20", "2020-03-22", "2020-04-25"))),
  labels = c("Before First Case", "After First Case", "After First Death"))

#I later proceeded to create a new column called Tweet_Content, which labeled each tweet as Covid-related or Non-Covid-related. In order to this, I used the grepl function, which searches for matches of a string or string vector. The argument below says that any tweet mentioning any of these words (Covid, Coronavirus, pandemic, respiratory, breathing, masks, hands, virus, flu, quarantine, or cases) would be classified as “Covid-related” in the new column. 

Maduro_df <- mutate(Maduro_df, text = ifelse(grepl("COVID|Coronavirus|coronavirus|pandemia|respiratorias|respiración|mascarillas|manos|Respiratoria|virus|gripe|cuarentena|casos", text),
                                             "Covid-related", "Non-Covid-related"))

