#' Residual plot of model
#'
#' @param fit a parsnip model object
#' @param data data.frame to create residuals with
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
viz_residuals <- function(fit, new_data) {
  augment(reg, new_data = new_data) %>%
    ggplot(aes(.pred, .resid)) +
    geom_point() +
    geom_abline(slope = 0, intercept = 0)
}
