library(testthat)
library(parsnip)
library(workflows)

set.seed(1234)

svm_spec <- nearest_neighbor() %>%
  set_mode("classification") %>%
  set_engine("kknn")

svm_fit <- workflow() %>%
  add_formula(Species ~ Petal.Length + Petal.Width) %>%
  add_model(svm_spec) %>%
  fit(iris)

test_that("viz_decision_boundary works", {

  vdiffr::expect_doppelganger(
    "viz_decision_boundary simple",
    viz_decision_boundary(svm_fit, iris)
  )

  vdiffr::expect_doppelganger(
    "viz_decision_boundary resolution",
    viz_decision_boundary(svm_fit, iris, resolution = 20)
  )

  vdiffr::expect_doppelganger(
    "viz_decision_boundary expand",
    viz_decision_boundary(svm_fit, iris, expand = 1)
  )
})
