#' @importFrom tidyr pivot_longer
#' @importFrom dplyr mutate everything desc filter bind_cols all_of select
#' @importFrom dplyr group_by summarize arrange slice pull
#' @importFrom tibble tibble rownames_to_column
#' @importFrom rlang .data enquo quo_name set_names
#' @importFrom parsnip augment
#' @importFrom ggplot2 labs ggplot aes geom_point geom_abline theme_minimal
#' @importFrom ggplot2 geom_raster aes_string scale_fill_gradient2
#' @importFrom stats prcomp var predict
#' @importFrom readr parse_number
#' @importFrom forcats fct_relevel fct_rev
#'

# ------------------------------------------------------------------------------
# nocov

#' @importFrom utils globalVariables
utils::globalVariables(
  c(".pred", ".resid", "name", "value", "contribution")
)

# nocov end
