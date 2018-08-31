#' Vizualize lexical dispersion plot
#'
#' @param data A data.frame.
#' @param var variable that contains the words
#' @param words Numerical or character. If numerical it will display the n
#'  most common words. If character will show the location of said strings.
#' @return ggplot2 object.
#' @examples
#'
#' library(tidytext)
#'
#' text_data <- tidytext::unnest_tokens(fairy_tales, text, text)
#' viz_dispersion(text_data, text)
#' viz_dispersion(text_data, text, "kissed")
#' @export
viz_dispersion <- function(data, var, words = 10) {
  var <- rlang::enquo(var)

  ## TODO implement s3 function for this
  if(class(words) == "numeric") {
    words <- dplyr::count(data, !!var, sort = TRUE) %>%
      dplyr::slice(seq_len(words))

    vec <- seq_len(10)
    names(vec) <- words$text
  }
  if(class(words) == "character") {
    vec <- seq_len(length(words))
    names(vec) <- words
  }

  plot_data <- data %>%
    dplyr::mutate_(x = ~ dplyr::row_number(),
           y = ~ names(vec)[dplyr::recode(text, !!!vec, .default = NA_integer_)]) %>%
    tidyr::drop_na() %>%
    dplyr::select_(.dots = c("x", "y"))

  ggplot2::ggplot(plot_data) +
    ggplot2::aes_(~x, ~y) +
    ggplot2::geom_point(shape = 18, alpha = 0.5) +
    ggplot2::labs(x = "Word offset",
                  y = NULL,
                  title = "Lexical Dispersion Plot")
}
