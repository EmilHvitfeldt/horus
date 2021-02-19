#' Viszualise
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
#' viz_classbalance(mtcars, vs)
viz_classbalance <- function(data, variable, n_max = 25) {
  enquo_variable <- enquo(variable)

  n_vars <- length(table(pull(data, !!enquo_variable)))
  if (n_vars > n_max) {
    cat(glue("The number of catagories is {n_vars} only the first {n_max} is ",
             "shown."))
    data[[quo_name(enquo_variable)]] <- data[[quo_name(enquo_variable)]] %>%
      as.factor() %>%
      fct_infreq() %>%
      fct_lump(n_max)
  }

  title <- paste0(
    "Class balence for ",
    format(nrow(data), big.mark = ","),
    " observations"
  )

  ggplot(data, aes(!!enquo_variable)) +
    geom_bar() +
    labs(title = title)
}
