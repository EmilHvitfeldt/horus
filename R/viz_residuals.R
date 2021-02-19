#' Residual plot of model
#'
#' @param fit a parsnip model object
#' @inheritParams parsnip:::augment.model_fit
#'
#' @return a ggplot2 object
#' @export
#'
#' @examples
#' library(parsnip)
#' reg <- linear_reg() %>%
#'   set_engine("lm") %>%
#'   set_mode("regression") %>%
#'   fit(mpg ~ ., data = mtcars)
#'
#' viz_residuals(reg, mtcars)
#'
#' linear_reg() %>%
#'   set_engine("lm") %>%
#'   set_mode("regression") %>%
#'   fit(mpg ~ ., data = mtcars) %>%
#'   viz_residuals(mtcars)
viz_residuals <- function(fit, new_data) {
  augment(fit, new_data = new_data) %>%
    ggplot(aes(.pred, .resid)) +
    geom_point() +
    geom_abline(slope = 0, intercept = 0) +
    theme_minimal()
}
