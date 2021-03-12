#' Draw Probability regions for Classification model
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
#'
#' iris2 <- iris
#' iris2$Species <- factor(iris2$Species == "setosa",
#'                         labels = c("setosa", "not setosa"))
#'
#' svm_spec <- svm_rbf() %>%
#'   set_mode("classification") %>%
#'   set_engine("kernlab")
#'
#' svm_fit <- workflow() %>%
#'   add_formula(Species ~ Petal.Length + Petal.Width) %>%
#'   add_model(svm_spec) %>%
#'   fit(iris2)
#'
#' viz_prob_region(svm_fit, iris2)
#'
#' viz_prob_region(svm_fit, iris2, resolution = 20)
#'
#' viz_prob_region(svm_fit, iris2, expand = 1)
viz_prob_region <- function(x, new_data, resolution = 100, expand = 0.1) {
  if (!inherits(x, "workflow")) {
    abort("`viz_decision_boundary()` only works with `workflow` objects.")
  }
  if (!x$trained) {
    abort("`x` must be a trained `workflow` object.")
  }

  var_names <- extract_variable_names(x, new_data, n_pred = 2)

  if (length(levels(new_data[[var_names$response]])) != 2) {
    abort("response must have only 2 levels.")
  }

  predict_area <- new_data %>%
    select(all_of(var_names$predictors)) %>%
    lapply(expanded_seq, expand, resolution) %>%
    expand.grid()

  predicted_prob <- predict(x, predict_area, type = "prob")

  predict_area %>%
    bind_cols(predicted_prob) %>%
    ggplot(
      aes_string(
        var_names$predictors[1],
        var_names$predictors[2],
        fill = names(predicted_prob)[1]
      )
    ) +
    geom_raster(alpha = 0.5) +
    scale_fill_gradient2(low = "blue", mid = "white", high = "green",
                         midpoint = 0.5) +
    geom_point(
      aes_string(
        var_names$predictors[1],
        var_names$predictors[2]
      ),
      color = "black", shape = 22, data = new_data, inherit.aes = FALSE
    ) +
    theme_minimal()
}
