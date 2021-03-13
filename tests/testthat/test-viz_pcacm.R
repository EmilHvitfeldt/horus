library(testthat)
test_that("viz_pcacm works", {

  vdiffr::expect_doppelganger(
    "viz_pcacm simple",
    viz_pcacm(mtcars),
    "viz_pcacm"
  )

  vdiffr::expect_doppelganger(
    "viz_pcacm components",
    viz_pcacm(mtcars, n_pca = 4),
    "viz_pcacm"
  )

  vdiffr::expect_doppelganger(
    "viz_pcacm loadings",
    viz_pcacm(mtcars, n_var = 5),
    "viz_pcacm"
  )

  vdiffr::expect_doppelganger(
    "viz_pcacm loadings components",
    viz_pcacm(mtcars, n_pca = 2, n_var = 8),
    "viz_pcacm"
  )
})
