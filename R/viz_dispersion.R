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
  var <- rlang::ensym(var)

  ## TODO implement helper function for this
  if (class(words) == "numeric") {
    words <- dplyr::count(data, !!var, sort = TRUE) %>%
      dplyr::slice(seq_len(words))

    vec <- dplyr::pull(words, !!var)
  }
  if (any(class(words) == "character")) {
    vec <- words
  }

  if (missing(group)) {
    factors <- dispersion_factor(dplyr::pull(data, !!var), vec)

    plot_data <- data %>%
      dplyr::mutate_(
        x = ~ dplyr::row_number(),
        y = ~factors
      ) %>%
      tidyr::drop_na() %>%
      dplyr::select_(.dots = c("x", "y"))

    x_limit <- nrow(data)
  } else {
    group <- rlang::ensym(group)

    plot_data <- tidyr::nest(data, !!var) %>%
      dplyr::mutate(data = purrr::map(data, ~ {
        factors <- dispersion_factor(dplyr::pull(.x, !!var), vec)
        .x %>%
          dplyr::mutate_(
            x = ~ seq_len(nrow(.x)),
            color = ~factors
          )
      })) %>%
      tidyr::unnest() %>%
      tidyr::drop_na() %>%
      dplyr::select_(.dots = c("x", "color", "y" = "book"))

    x_limit <- tidyr::nest(data, !!var)$data %>%
      sapply(nrow) %>%
      max()
  }

  if (is.null(symbol)) {
    symbol <- ifelse(nrow(plot_data) > 200, 108, 18)
  }

  if (missing(group)) {
    base_plot <- ggplot2::ggplot(plot_data) +
      ggplot2::aes_(~x, ~y)
  } else {
    base_plot <- ggplot2::ggplot(plot_data) +
      ggplot2::aes_(~x, ~y, color = ~color)
  }
  base_plot +
    ggplot2::geom_point(shape = symbol, alpha = alpha) +
    ggplot2::scale_y_discrete(drop = FALSE) +
    ggplot2::xlim(c(1, x_limit)) +
    ggplot2::guides(color = guide_legend(override.aes = list(shape = c(18)))) +
    ggplot2::labs(
      x = "Word Offset",
      y = NULL,
      title = "Lexical Dispersion Plot"
    )
}

dispersion_factor <- function(x, names) {
  replacement <- seq_len(length(names))
  names(replacement) <- names

  factor(dplyr::recode(x, !!!replacement,
    .default = NA_integer_
  ), levels = replacement, labels = names)
}
