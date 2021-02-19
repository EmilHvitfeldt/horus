#' Vizualize the predicted probalities for each class
#'
#' @param model A `model_fit` object from the parsnip package.
#' @param new_data A data.frame to run predictions on.
#' @param truth A vector of true classes used to color probalities.
#'     Defaults to NULL.
#'
#' @return ggplot2 object.
#' @export
viz_prob_distribution <- function(model, new_data, truth) {
  UseMethod("viz_prob_distribution")
}

#' @rdname viz_prob_distribution
#' @export
viz_prob_distribution.default <- function(model, new_data, truth) {
  stop("`model` must be a `model_fit` object from the parsnip package.",
    call. = FALSE
  )
}

#' @rdname viz_prob_distribution
#' @export
#'
#' @examples
#' library(parsnip)
#' library(ranger)
#'
#' fit_model <- rand_forest("classification") %>%
#'   set_engine("ranger") %>%
#'   fit(Species ~ ., data = iris)
#'
#' viz_prob_distribution(fit_model, new_data = iris)
#'
#' viz_prob_distribution(fit_model, new_data = iris, truth = iris$Species)
viz_prob_distribution.model_fit <- function(model, new_data, truth = NULL) {
  if (model$spec$mode != "classification") {
    stop("`model` must be a classification model.", call. = FALSE)
  }

  plotting_data <- predict(model, new_data, type = "prob")

  if (is.null(truth)) {
    plotting_data <- plotting_data %>%
      pivot_longer(cols = everything())
  } else {
    plotting_data <- plotting_data %>%
      mutate(truth = truth) %>%
      pivot_longer(cols = -truth) %>%
      mutate(correct = factor(
        gsub(".pred_", "", .data$name) == .data$truth,
        c(TRUE, FALSE),
        c("Yes", "No")
      )) %>%
      filter(gsub(".pred_", "", .data$name) == .data$truth)
  }

  out <- plotting_data %>%
    ggplot(aes(.data$value)) +
    geom_histogram(bins = 50) +
    facet_grid(~ .data$name) +
    theme_minimal() +
    labs(x = "Predicted probability")

  if (!is.null(truth)) {
    out <- out +
      aes(fill = .data$correct) +
      labs(fill = "Correctlty predicted")
  }
  out
}
