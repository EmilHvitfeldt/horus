#' PCA component measures
#'
#' @param x a data.frame
#' @param n_pca Number of Principle components to show
#' @param n_var Number of Variables to show
#'
#' @return a ggplot2 object
#' @export
#'
#' @examples
#' viz_pcacm(mtcars)
#' viz_pcacm(USArrests)
#' viz_pcacm(beaver1)
viz_pcacm <- function(x, n_pca = 10, n_var = 10) {
  tidy_rotation <- as.data.frame(prcomp(x, rank = n_pca)$rotation) %>%
    rownames_to_column("var") %>%
    pivot_longer(-var) %>%
    filter(name %in% paste0("PC", seq_len(n_pca)))

  order <- tidy_rotation %>%
    group_by(var) %>%
    summarize(contribution = sum(abs(value) * 1 / parse_number(name))) %>%
    arrange(desc(contribution)) %>%
    slice(seq_len(n_var)) %>%
    pull(var)

  tidy_rotation %>%
    filter(var %in% order) %>%
    mutate(var = fct_relevel(var, order)) %>%
    ggplot(aes(var, fct_rev(fct_relevel(name, paste0("PC", seq_len(n_pca)))), fill = value)) +
    geom_raster() +
    scale_fill_gradient2(low = "purple",
                         mid = "grey90",
                         high ="orange") +
    theme_minimal() +
    labs(y = "Principle Component",
         x = "Variable")
}
