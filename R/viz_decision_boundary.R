#' Title
#'
#' @param x fitted workflow object
#' @param new_data data frame
#' @param grid Logical, whether to use grid method to show decision boundary.
#'   Defaults to TRUE.
#' @param resolution Number of squared in grid. Defaults to 100.
#' @param expand Expansion rate. Defaults to 0.1. This means that the width and
#'   height of the shaded area is 10% wider then the rectangle containing the
#'   data.
#'
#' @return ggplot object
#' @export
#'
#' @examples
#' library(parsnip)
#' library(workflows)
#' lm_spec <- svm_rbf() %>%
#'   set_mode("classification") %>%
#'   set_engine("kernlab")
#'
#' lr_fit <- workflow() %>%
#'   add_formula(Species ~ Petal.Length + Petal.Width) %>%
#'   add_model(lm_spec) %>%
#'   fit(iris)
#'
#' viz_decision_boundary(lr_fit, iris)
viz_decision_boundary <- function(x, new_data, grid = TRUE, resolution = 100,
                                  expand = 0.1) {
  if (names(x$pre$actions) == "variables") {
    predictors <- eval_tidy(
      x$pre$actions$variables$predictors,
      set_names(names(new_data))
    )

    response <- eval_tidy(
      x$pre$actions$variables$outcome,
      set_names(names(new_data))
    )

    if (length(predictors) != 2) {
      abort("`x` must have only 2 predictors.")
    }
  } else if (names(x$pre$actions) == "formula") {
    if (length(x$pre$actions$formula$formula) != 3) {
      abort("`x` must have only 2 predictors.")
    }
    predictors <- x$pre$actions$formula$formula[[3]][c(2, 3)]
    predictors <- as.character(predictors)

    response <- as.character(x$pre$actions$formula$formula[[2]])
  }

  predict_area <- new_data %>%
    select(all_of(predictors)) %>%
    lapply(function(x) {
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
    }) %>%
    expand.grid()

  predict_area %>%
    bind_cols(predict(x, predict_area)) %>%
    ggplot(aes_string(predictors[1], predictors[2], fill = ".pred_class")) +
    geom_raster(alpha = 0.2) +
    geom_point(aes_string(predictors[1], predictors[2], fill = response),
      color = "black", shape = 22, data = new_data, inherit.aes = FALSE
    )
}
