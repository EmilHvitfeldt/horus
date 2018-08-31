set.seed(12345)
library(tidyverse)
#devtools::install_github("EmilHvitfeldt/hcandersenr")
select_books <- hcandersenr::hcandersen_en %>%
  pull(book) %>%
  unique() %>%
  sample(size = 5)

fairy_tales <- hcandersenr::hcandersen_en %>%
  filter(book %in% select_books)
