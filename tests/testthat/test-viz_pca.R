library(testthat)
test_that("viz_pca works", {

  vdiffr::expect_doppelganger(
    "viz_pca simple",
    viz_pca(iris, Species),
    "viz_pca"
  )

  vdiffr::expect_doppelganger(
    "viz_pca components",
    viz_pca(iris, Species, components = c(3, 1)),
    "viz_pca"
  )

  vdiffr::expect_doppelganger(
    "viz_pca loadings",
    viz_pca(iris, Species, loadings = TRUE),
    "viz_pca"
  )
})
