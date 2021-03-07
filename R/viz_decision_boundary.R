#' Draw Decision boundary for Classification model
#'
#' This function is mostly useful in an educational setting. Can only be used
#' with trained workflow objects with 2 numeric predictor variables.
#'
#' @param x trained `workflows::workflow` object.
#' @param new_data A data frame or tibble for whom the preprocessing will be
#'   applied.
#' @param resolution Number of squared in grid. Defaults to 100.
#' @param expand Expansion rate. Defaults to 0.1. This means that the width and
#'   height of the shaded area is 10% wider then the rectangle containing the
#'   data.
#'
#' The chart have been minimally modified to allow for easier styling.
#'
#' @return `ggplot2::ggplot` object
#' @export
#'
#' @examples
#' library(parsnip)
#' library(workflows)
#' svm_spec <- svm_rbf() %>%
#'   set_mode("classification") %>%
#'   set_engine("kernlab")
#'
#' svm_fit <- workflow() %>%
#'   add_formula(Species ~ Petal.Length + Petal.Width) %>%
#'   add_model(svm_spec) %>%
#'   fit(iris)
#'
#' viz_decision_boundary(svm_fit, iris)
#'
#' viz_decision_boundary(svm_fit, iris, resolution = 20)
#'
#' viz_decision_boundary(svm_fit, iris, expand = 1)
viz_decision_boundary <- function(x, new_data, resolution = 100, expand = 0.1) {

  if (!inherits(x, "workflow")) {
    abort("`viz_decision_boundary()` only works with `workflow` objects.")
  }
  if (!x$trained) {
    abort("`x` must be a trained `workflow` object.")
  }

  var_names <- extract_variable_names(x, new_data)

  predict_area <- new_data %>%
    select(all_of(var_names$predictors)) %>%
    lapply(expanded_seq, expand, resolution) %>%
    expand.grid()

  predict_area %>%
    bind_cols(predict(x, predict_area)) %>%
    ggplot(
      aes_string(
        var_names$predictors[1],
        var_names$predictors[2],
        fill = ".pred_class"
      )
    ) +
    geom_raster(alpha = 0.2) +
    geom_point(
      aes_string(
        var_names$predictors[1],
        var_names$predictors[2],
        fill = var_names$response
      ),
      color = "black", shape = 22, data = new_data, inherit.aes = FALSE
    ) +
    theme_minimal()
}

expanded_seq <- function(x, expand, resolution) {
  x_range <- range(x, na.rm = TRUE)

  x_range_width <- x_range[2] - x_range[1]

  sequence <- seq(
    from = x_range[1] - x_range_width * expand / 2,
    to = x_range[2] + x_range_width * expand / 2,
    length.out = resolution
  )

  if (is.integer(x)) {
    sequence <- unique(as.integer(sequence))
  }
  sequence
}
