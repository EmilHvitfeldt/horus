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
