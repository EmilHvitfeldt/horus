#' Vizualize t-SNE
#'
#' @param data A data.frame.
#' @param label variable to color with.
#' @return ggplot2 object.
#' @examples
#' viz_tsne(iris, Species)
#' viz_tsne(dplyr::select(iris, -Species), Sepal.Length)
#' @export
viz_tsne <- function(data, label) {
  label_enquo <- rlang::enquo(label)

  names <- paste0("V", c(1, 2))

  tsne_data <- data %>%
    dplyr::select(-!!label_enquo) %>%
    as.matrix() %>%
    Rtsne::Rtsne(check_duplicates = FALSE)

  tibble::as_tibble(tsne_data$Y) %>%
    dplyr::mutate(Label = dplyr::pull(data, !!label_enquo)) %>%
    ggplot2::ggplot() +
    ggplot2::aes_string(names[1], names[2], color = "Label") +
    ggplot2::geom_point() +
    ggplot2::labs(x = "",
                  y = "",
                  title = "t-SNE Manifold")
}
