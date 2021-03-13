library(parsnip)

reg <- linear_reg() %>%
  set_engine("lm") %>%
  set_mode("regression") %>%
  fit(mpg ~ ., data = mtcars)

test_that("viz_residuals works", {

  vdiffr::expect_doppelganger(
    "viz_residuals simple",
    viz_residuals(reg, mtcars),
    "viz_residuals"
  )
})
