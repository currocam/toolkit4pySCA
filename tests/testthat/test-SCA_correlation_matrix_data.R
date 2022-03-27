test_that("it works", {
  db <- pySCA_HBG2_HUMAN
  data <- SCA_correlation_matrix_data(db)
  expect_equal(nrow(data), 139)
})
test_that("empty list gives error", {
  SCA_correlation_matrix_data(list()) %>%
    testthat::expect_error()
})
