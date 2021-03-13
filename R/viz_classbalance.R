#' Visualise Class Imbalance
#'
#' @param data A data.frame.
#' @param variable target variable to show balance for.
#' @param n_max integer, maximum number of classes shown before lumping.
#' Defaults to 25.
#'
#' @return ggplot2 object.
#' @export
#'
#' @examples
#' viz_classbalance(mnist_sample, class)
viz_classbalance <- function(data, variable, n_max = 25) {
  enquo_variable <- enquo(variable)

  if (!is.factor(data[[quo_name(enquo_variable)]])) {
    abort("`variable` must be a factor")
  }

  n_vars <- length(table(pull(data, !!enquo_variable)))
  if (n_vars > n_max) {
    data[[quo_name(enquo_variable)]] <- data[[quo_name(enquo_variable)]] %>%
      as.factor() %>%
      fct_infreq() %>%
      fct_lump(n_max)

    n_shown <- length(levels(data[[quo_name(enquo_variable)]])) - 1
    inform(glue("The number of catagories is {n_vars} only the first ",
                "{n_shown} is shown."))
  }

  title <- paste0(
    "Class balence for ",
    format(nrow(data), big.mark = ","),
    " observations"
  )

  ggplot(data, aes(!!enquo_variable)) +
    geom_bar() +
    labs(title = title) +
    theme_minimal()
}
