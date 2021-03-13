#' Vizualize t-SNE
#'
#' @param data A data.frame.
#' @param label variable to color with.
#' @return ggplot2 object.
#' @examples
#' library(dplyr)
#' viz_tsne(iris, Species)
#' viz_tsne(select(iris, -Species), Sepal.Length)
#' @export
viz_tsne <- function(data, label) {
  label_enquo <- enquo(label)

  names <- paste0("V", c(1, 2))

  tsne_data <- data %>%
    select(-!!label_enquo) %>%
    as.matrix() %>%
    Rtsne(check_duplicates = FALSE)

  plotting_data <- tsne_data$Y

  colnames(plotting_data) <- names

  as_tibble(plotting_data) %>%
    mutate(Label = pull(data, !!label_enquo)) %>%
    ggplot() +
    aes_string(names[1], names[2], color = "Label") +
    geom_point() +
    labs(
      x = "",
      y = "",
      title = "t-SNE Manifold"
    ) +
    theme_minimal()
}
