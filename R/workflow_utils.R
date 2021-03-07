extract_variable_names <- function(x, new_data) {
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
  } else if (names(x$pre$actions) == "recipe") {
    var_info <- x$pre$actions$recipe$recipe$var_info
    predictors <- var_info$variable[var_info$role == "predictor"]
    response <- var_info$variable[var_info$role == "outcome"]
  }

  list(predictors = predictors, response = response)
}
