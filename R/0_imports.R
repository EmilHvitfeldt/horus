#' @importFrom tidyr pivot_longer drop_na nest unnest
#' @importFrom dplyr mutate everything desc filter bind_cols all_of select
#' @importFrom dplyr group_by summarize arrange slice pull count row_number
#' @importFrom dplyr select_ mutate_ recode
#' @importFrom tibble tibble rownames_to_column as_tibble
#' @importFrom rlang .data enquo quo_name set_names ensym eval_tidy abort
#' @importFrom parsnip augment
#' @importFrom ggplot2 labs ggplot aes geom_point geom_abline theme_minimal
#' @importFrom ggplot2 geom_raster aes_string scale_fill_gradient2 guide_legend
#' @importFrom ggplot2 geom_text geom_histogram facet_grid geom_bar aes_
#' @importFrom ggplot2 scale_y_discrete xlim guides unit arrow geom_segment
#' @importFrom glue glue
#' @importFrom stats prcomp var predict
#' @importFrom readr parse_number
#' @importFrom forcats fct_relevel fct_rev fct_infreq fct_lump
#' @importFrom purrr map
#' @importFrom Rtsne Rtsne
#'

# ------------------------------------------------------------------------------
# nocov

#' @importFrom utils globalVariables
utils::globalVariables(
  c(".pred", ".resid", "name", "value", "contribution")
)

# nocov end
