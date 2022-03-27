test_that("is 192 sequences", {
  db <- pySCA_HBG2_HUMAN
  db$sequence$hd <- make.unique(db$sequence$hd)
  data <- sequence_correlation_matrix_projections_data(db)
  data %>% dplyr::pull("hd") %>%
    unique() %>%
  expect_equal(db$sequence$hd)
})
test_that("empty list gives error", {
  sequence_correlation_matrix_projections_data(list()) %>%
    testthat::expect_error()
})
