library(keras)
library(recipes)
library(embed)
library(purrr)
library(dplyr)
set.seed(1234)

mnist_raw <- dataset_mnist()

tidy_mnist <- map_dfc(1:28, ~tibble::as_tibble(mnist_raw$train$x[, , .x])) %>%
  mutate(class = factor(mnist_raw$train$y))

mnist_sample <- recipe(class ~ ., data = slice_sample(tidy_mnist, prop = 0.02)) %>%
  step_umap(all_predictors(), num_comp = 2) %>%
  prep() %>%
  juice()

usethis::use_data(mnist_sample, overwrite = TRUE)
