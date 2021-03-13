library(testthat)
library(parsnip)
library(workflows)

set.seed(1234)

knn_spec <- nearest_neighbor() %>%
  set_mode("regression") %>%
  set_engine("kknn")

knn_fit <- workflow() %>%
  add_formula(mpg ~ disp) %>%
  add_model(knn_spec) %>%
  fit(mtcars)

test_that("viz_fitted_line works", {

  vdiffr::expect_doppelganger(
    "viz_fitted_line simple",
    viz_fitted_line(knn_fit, mtcars),
    "viz_fitted_line"
  )

  vdiffr::expect_doppelganger(
    "viz_fitted_line resolution",
    viz_fitted_line(knn_fit, mtcars, resolution = 20),
    "viz_fitted_line"
  )

  vdiffr::expect_doppelganger(
    "viz_fitted_line expand",
    viz_fitted_line(knn_fit, mtcars, expand = 1),
    "viz_fitted_line"
  )

  vdiffr::expect_doppelganger(
    "viz_fitted_line style",
    viz_fitted_line(knn_fit, mtcars, color = "pink", size = 4),
    "viz_fitted_line"
  )

})
