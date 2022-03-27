test_that("it works", {
  db <- pySCA_HBG2_HUMAN
  data <- position_specific_conservation_data(db)
  expect_equal(nrow(data), 139)
})
test_that("empty list gives error", {
  pairwise_sequence_identities_data(list()) %>%
    testthat::expect_error()
})
