library(testthat)
library(dplyr)

set.seed(1234)

test_that("viz_tsne works", {

  vdiffr::expect_doppelganger(
    "viz_tsne simple factor",
    viz_tsne(iris, Species),
    "viz_tsne"
  )

  vdiffr::expect_doppelganger(
    "viz_tsne simple numeric",
    viz_tsne(select(iris, -Species), Sepal.Length),
    "viz_tsne"
  )
})
