#' Vizualize principal pomponents
#'
#' @param data A data.frame.
#' @param label variable to color with.
#' @param components principal components to showcase.
#' @param loadings Set this to true if you want to see the PCA loadings.
#' @return ggplot2 object.
#' @examples
#' viz_pca(iris, Species)
#' viz_pca(iris, Species, c(3, 1))
#' viz_pca(iris, Species, loadings = TRUE)
#' @export
viz_pca <- function(data, label, components = c(1, 2), loadings = FALSE) {
  label_enquo <- enquo(label)

  names <- paste0("PC", components)

  pca_obj <- data %>%
    select(-!!label_enquo) %>%
    as.matrix() %>%
    prcomp()

  plot_data <- as_tibble(pca_obj$x) %>%
    mutate(Label = pull(data, !!label_enquo))

  p <- plot_data %>%
    ggplot() +
    aes_string(names[1], names[2], color = "Label") +
    geom_point() +
    labs(
      x = glue("Principal Component {components[1]}"),
      y = glue("Principal Component {components[2]}"),
      title = "Principal Component plot"
    )

  if (loadings) {
    loadings_data <- pca_obj$rotation[, components] %>%
      as.data.frame() %>%
      rownames_to_column()
    arrow <- arrow(length = unit(0.03, "npc"))
    p <- p +
      geom_segment(aes_string(
        x = 0, y = 0,
        xend = names[1],
        yend = names[2]
      ),
      data = loadings_data, inherit.aes = FALSE,
      arrow = arrow
      ) +
      geom_text(aes_string(names[1], names[2], label = "rowname"),
        data = loadings_data, inherit.aes = FALSE
      )
  }

  p
}
