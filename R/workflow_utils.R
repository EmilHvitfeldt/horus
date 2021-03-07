extract_variable_names <- function(x, new_data, n_pred) {
  if (names(x$pre$actions) == "variables") {
    predictors <- eval_tidy(
      x$pre$actions$variables$predictors,
      set_names(names(new_data))
    )

    response <- eval_tidy(
      x$pre$actions$variables$outcome,
      set_names(names(new_data))
    )
  } else if (names(x$pre$actions) == "formula") {
    predictors <- intersect(
      as.character(x$pre$actions$formula$formula[[3]]),
      names(new_data)
    )

    response <- as.character(x$pre$actions$formula$formula[[2]])
  } else if (names(x$pre$actions) == "recipe") {
    var_info <- x$pre$actions$recipe$recipe$var_info
    predictors <- var_info$variable[var_info$role == "predictor"]
    response <- var_info$variable[var_info$role == "outcome"]
  }

  if (length(predictors) != n_pred) {
    abort(glue("`x` must have only {n_pred} predictors."))
  }

  list(predictors = predictors, response = response)
}
