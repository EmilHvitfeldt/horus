#' Draw fitted regression line
#'
#' This function is mostly useful in an educational setting. Can only be used
#' with trained workflow objects with 1 numeric predictor variable.
#'
#' @param x trained `workflows::workflow` object.
#' @param new_data A data frame or tibble for whom the preprocessing will be
#'     applied.
#' @param resolution Number of squared in grid. Defaults to 100.
#' @param expand Expansion rate. Defaults to 0.1. This means that the width of
#'     the plotting area is 10 percent wider then the data.
#' @param color Character, color of the fitted line. Passed to `geom_line()`.
#'     Defaults to `"blue"`.
#' @param size Numeric, size of the fitted line. Passed to `geom_line()`.
#'     Defaults to `1`.
#'
#' @details
#' The chart have been minimally modified to allow for easier styling.
#'
#' @return `ggplot2::ggplot` object
#' @export
#'
#' @examples
#' library(parsnip)
#' library(workflows)
#' lm_spec <- linear_reg() %>%
#'   set_mode("regression") %>%
#'   set_engine("lm")
#'
#' lm_fit <- workflow() %>%
#'   add_formula(mpg ~ disp) %>%
#'   add_model(lm_spec) %>%
#'   fit(mtcars)
#'
#' viz_fitted_line(lm_fit, mtcars)
#'
#' viz_fitted_line(lm_fit, mtcars, expand = 1)
viz_fitted_line <- function(x, new_data, resolution = 100, expand = 0.1,
                            color = "blue", size = 1) {

  if (!inherits(x, "workflow")) {
    abort("`viz_fitted_line()` only works with `workflow` objects.")
  }
  if (!x$trained) {
    abort("`x` must be a trained `workflow` object.")
  }

  var_names <- extract_variable_names(x, new_data, n_pred = 1)

  predict_area <- new_data %>%
    select(all_of(var_names$predictors)) %>%
    lapply(expanded_seq, expand, resolution) %>%
    expand.grid()

  fitted_line <- bind_cols(predict_area, predict(x, predict_area))

  new_data %>%
    ggplot(
      aes_string(
        var_names$predictors[1],
        var_names$response
      )
    ) +
    geom_point(alpha = 0.5) +
    geom_line(
      aes_string(
        var_names$predictors[1],
        ".pred"
      ),
      color = color,
      size = size,
      data = fitted_line,
      inherit.aes = FALSE
    ) +
    theme_minimal() +
    xlim(range(predict_area[[1]]))
}
