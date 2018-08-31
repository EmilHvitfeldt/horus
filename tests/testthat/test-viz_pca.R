context("test-viz_pca")
library(ggplot2)

test_that("it returns a ggplot object", {
  p <- viz_pca(iris, Species)
  expect_true(is.ggplot(p))
})
