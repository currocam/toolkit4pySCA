test_that("is a 192x102", {
  db <- pySCA_HBG2_HUMAN
  db$sequence$hd <- make.unique(db$sequence$hd)
  data <- pairwise_sequence_identities_data(db)
  expect_equal(nrow(data), 18528)
})
test_that("empty list gives error", {
  pairwise_sequence_identities_data(list()) %>%
  testthat::expect_error()
})

test_that("empty list gives error", {
  pairwise_sequence_identities_data(pySCA_HBG2_HUMAN) %>%
    testthat::expect_warning()
})
