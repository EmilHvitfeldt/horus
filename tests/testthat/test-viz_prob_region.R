library(testthat)
library(parsnip)
library(workflows)

set.seed(1234)

iris2 <- iris
iris2$Species <- factor(iris2$Species == "setosa",
                        labels = c("setosa", "not setosa"))

svm_spec <- svm_rbf() %>%
  set_mode("classification") %>%
  set_engine("kernlab")

svm_fit <- workflow() %>%
  add_formula(Species ~ Petal.Length + Petal.Width) %>%
  add_model(svm_spec) %>%
  fit(iris2)

svm_fit_full <- workflow() %>%
  add_formula(Species ~ Petal.Length + Petal.Width) %>%
  add_model(svm_spec) %>%
  fit(iris)

test_that("viz_prob_region works", {

  vdiffr::expect_doppelganger(
    "viz_prob_region simple",
    viz_prob_region(svm_fit, iris2),
    "viz_prob_region"
  )

  vdiffr::expect_doppelganger(
    "viz_prob_region resolution",
    viz_prob_region(svm_fit, iris2, resolution = 20),
    "viz_prob_region"
  )

  vdiffr::expect_doppelganger(
    "viz_prob_region expand",
    viz_prob_region(svm_fit, iris2, expand = 1),
    "viz_prob_region"
  )
})

test_that("viz_prob_region facet works", {

  expect_error(
    viz_prob_region(svm_fit_full, iris)
  )

  vdiffr::expect_doppelganger(
    "viz_prob_region facet simple",
    viz_prob_region(svm_fit_full, iris, facet = TRUE),
    "viz_prob_region"
  )

  vdiffr::expect_doppelganger(
    "viz_prob_region facet resolution",
    viz_prob_region(svm_fit_full, iris, resolution = 20, facet = TRUE),
    "viz_prob_region"
  )

  vdiffr::expect_doppelganger(
    "viz_prob_region facet expand",
    viz_prob_region(svm_fit_full, iris, expand = 1, facet = TRUE),
    "viz_prob_region"
  )
})




