#' Vizualize lexical dispersion plot
#'
#' @param data A data.frame.
#' @param var variable that contains the words to be visualized.
#' @param group If present with show a group for each line with the words color
#'  coded.
#' @param words Numerical or character. If numerical it will display the n
#'  most common words. If character will show the location of said strings.
#' @param symbol The word symbol. Default to is 18 (filed diamond) when number
#'  of points are less then 200 and to 108 (vertical line) when there are more
#'  then 200 points.
#' @param alpha color transperency of the word symbols.
#' @return ggplot2 object.
#' @examples
#' library(tidytext)
#'
#' text_data <- unnest_tokens(fairy_tales, word, text)
#' viz_dispersion(text_data, word)
#' viz_dispersion(text_data, word, words = c("branches", "not a word"))
#' viz_dispersion(text_data, word, symbol = "2")
#' viz_dispersion(text_data, word, group = book)
#' @export
viz_dispersion <- function(data, var, group, words = 10, symbol = NULL,
                           alpha = 0.7) {
  var <- ensym(var)

  ## TODO implement helper function for this
  if (class(words) == "numeric") {
    words <- count(data, !!var, sort = TRUE) %>%
      slice(seq_len(words))

    vec <- pull(words, !!var)
  }
  if (any(class(words) == "character")) {
    vec <- words
  }

  if (missing(group)) {
    factors <- dispersion_factor(pull(data, !!var), vec)

    plot_data <- data %>%
      mutate_(
        x = ~row_number(),
        y = ~factors
      ) %>%
      drop_na() %>%
      select_(.dots = c("x", "y"))

    x_limit <- nrow(data)
  } else {
    group <- ensym(group)

    plot_data <- nest(data, !!var) %>%
      mutate(data = map(data, ~ {
        factors <- dispersion_factor(pull(.x, !!var), vec)
        .x %>%
          mutate_(
            x = ~ seq_len(nrow(.x)),
            color = ~factors
          )
      })) %>%
      unnest() %>%
      drop_na() %>%
      select_(.dots = c("x", "color", "y" = "book"))

    x_limit <- nest(data, !!var)$data %>%
      sapply(nrow) %>%
      max()
  }

  if (is.null(symbol)) {
    symbol <- ifelse(nrow(plot_data) > 200, 108, 18)
  }

  if (missing(group)) {
    base_plot <- ggplot(plot_data) +
    aes_(~x, ~y)
  } else {
    base_plot <- ggplot(plot_data) +
      aes_(~x, ~y, color = ~color)
  }
  base_plot +
    geom_point(shape = symbol, alpha = alpha) +
    scale_y_discrete(drop = FALSE) +
    xlim(c(1, x_limit)) +
    guides(color = guide_legend(override.aes = list(shape = c(18)))) +
    labs(
      x = "Word Offset",
      y = NULL,
      title = "Lexical Dispersion Plot"
    )
}

dispersion_factor <- function(x, names) {
  replacement <- seq_len(length(names))
  names(replacement) <- names

  factor(recode(x, !!!replacement,
    .default = NA_integer_
  ), levels = replacement, labels = names)
}
