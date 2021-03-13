#' Sample of 5 fairly tales from H.C. Andersen
#'
#' Includes the fairy tales "A leaf from heaven", "A story",
#' "The bird of folklore", "The flea and the professor" and "The rags".
#'
#' @format A tibble with 486 obs. of 2 variables.
"fairy_tales"

#' Down-sampled MNIST
#'
#' this data set is a down-sampled version of the MNIST data set which have been
#' umap'ed down to 2 dimensions.
#'
#' @source \url{http://yann.lecun.com/exdb/mnist/}
#' @format A data frame with 1200 rows and 3 variables:
#' \describe{
#'   \item{class}{Factor, values 0 through 9.}
#'   \item{umap_1}{Numeric.}
#'   \item{umap_2}{Numeric.}
#' }
"mnist_sample"
