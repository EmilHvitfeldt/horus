#' Create Lambda chart for glmnet object
#'
#' @param fit parsnip fit object
#'
#' @return ggplot2 object
#' @export
#'
#' @examples
#' library(parsnip)
#' library(glmnet)
#' linear_reg_glmnet_spec <-
#'   linear_reg(penalty = 0, mixture = 1) %>%
#'   set_engine('glmnet')
#'
#' lm_fit <- fit(linear_reg_glmnet_spec, data = mtcars, mpg ~ .)
#'
#' glmnet_coef_plot(lm_fit)
glmnet_coef_plot <- function(fit) {
  as_tibble(t(as.matrix(fit$fit$beta))) %>%
    mutate(lambda = fit$fit$lambda) %>%
    pivot_longer(-lambda) %>%
    ggplot(aes(lambda, value, group = name)) +
    geom_line() +
    scale_x_log10()
}
