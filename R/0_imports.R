#' @importFrom dplyr all_of arrange bind_cols count desc everything filter
#' @importFrom dplyr group_by mutate mutate_ pull recode row_number select
#' @importFrom dplyr select_ slice summarize
#' @importFrom forcats fct_infreq fct_lump fct_relevel fct_rev
#' @importFrom ggplot2 aes aes_ aes_string arrow facet_grid facet_wrap
#' @importFrom ggplot2 geom_abline geom_bar geom_histogram geom_line
#' @importFrom ggplot2 geom_point geom_raster geom_segment geom_text ggplot
#' @importFrom ggplot2 guide_legend guides labs scale_alpha scale_fill_gradient2
#' @importFrom ggplot2 scale_y_discrete theme_minimal unit xlim scale_x_log10
#' @importFrom glue glue
#' @importFrom magrittr %>%
#' @importFrom parsnip augment
#' @importFrom purrr map
#' @importFrom readr parse_number
#' @importFrom rlang .data abort enquo ensym eval_tidy inform quo_name set_names
#' @importFrom Rtsne Rtsne
#' @importFrom stats prcomp predict var
#' @importFrom tibble as_tibble rownames_to_column tibble
#' @importFrom tidyr drop_na nest pivot_longer unnest
#' @importFrom utils globalVariables
NULL
#'

# ------------------------------------------------------------------------------
# nocov

utils::globalVariables(
  c(".pred", ".resid", "name", "value", "contribution", "lambda")
)

# nocov end
