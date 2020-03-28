
library(rvest)
library(fs)
library(tidyverse)


######################################## test with season 1 episode 1
raw <- read_html("raw_data/0101.html")


episode_name <- raw %>% 
  html_node("h1") %>% 
  html_text()

writer <- raw %>%
  html_node("font") %>% 
  html_text() %>% 
  str_trim()


names <- raw %>%
  html_nodes("p") %>% 
  html_nodes("b") %>% 
  html_text() %>% 
  str_remove(":")

  
# regex to extract figure names, and to remove them from lines
names_regex <- str_c(unique(names), collapse = "|") 
names_regex


figures <- raw %>% 
  html_nodes("p") %>% 
  html_text() %>% 
  str_extract(names_regex)
  

lines <- raw %>% 
  html_nodes("p") %>% 
  html_text() %>% 
  str_remove(names_regex) %>%
  str_remove("^: ")

################################## extract texxt from season 1 



parser <- function(path) {
  raw <- read_html(path)
  
  episode_name <- raw %>% 
    html_node("h1") %>% 
    html_text()
  
  writer <- raw %>%
    html_node("font") %>% 
    html_text() %>% 
    str_trim()
  
  names <- raw %>%
    html_nodes("p") %>% 
    html_nodes("b") %>% 
    html_text() %>% 
    str_remove(":")
  
  names_regex <- str_c(unique(names), collapse = "|") 
  
  figures <- raw %>% 
    html_nodes("p") %>% 
    html_text() %>% 
    str_extract(names_regex)
  
  lines <- lines <- raw %>% 
    html_nodes("p") %>% 
    html_text() %>% 
    str_remove(names_regex) %>%
    str_remove("^: ")
  
  tibble(episode_name = episode_name,
         writer = writer,
         figure = figures,
         line = lines)
}

files <- list.files(path = "raw_data", pattern = "01..\\.html") 
files <- str_c("raw_data/", files)

files %>% 
  map_dfr(parser, .id = "episode") %>% 
  write_csv("output_data/season_1.csv")


