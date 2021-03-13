library(testthat)

test_that("viz_classbalance works", {

  vdiffr::expect_doppelganger(
    "viz_classbalance simple",
    viz_classbalance(mnist_sample, class),
    "viz_classbalance"
  )

  vdiffr::expect_doppelganger(
    "viz_classbalance n_max 2",
    viz_classbalance(mnist_sample, class, n_max = 2),
    "viz_classbalance"
  )

  vdiffr::expect_doppelganger(
    "viz_classbalance n_max 4 ties",
    expect_message(
      viz_classbalance(mnist_sample, class, n_max = 4),
      "5"
    ),
    "viz_classbalance"
  )

})
