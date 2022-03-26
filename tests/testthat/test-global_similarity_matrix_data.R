test_that("is a 192x102", {
  db <- pySCA_HBG2_HUMAN
  db$sequence$hd <- make.unique(db$sequence$hd)
  data <- global_similarity_matrix_data(db)
  expect_equal(nrow(data), 192)
  expect_equal(ncol(data), 192)
})
test_that("empty list gives error", {
  global_similarity_matrix_data(list()) %>%
    testthat::expect_error()
})

test_that("empty list gives error", {
  global_similarity_matrix_data(pySCA_HBG2_HUMAN) %>%
    testthat::expect_warning()
})
