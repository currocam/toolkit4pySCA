testthat::skip_on_cran()
testthat::skip_on_ci()
test_that("error parsing works", {
  import_pySCA_module_using_reticulate() %>%
    expect_error()
})

test_that("using empty virtualenv fails", {
  import_pySCA_module_using_reticulate(virtualenv = "r-pySCA") %>%
    expect_error()
})

# test_that("installing virtualenv works", {
#   import_pySCA_module_using_reticulate(
#     virtualenv = "r-pySCA",force_installing = TRUE) %>%
#     testthat::expect_success()
# })
#
# test_that("not empty virtualenv works", {
#   import_pySCA_module_using_reticulate(virtualenv = "r-pySCA") %>%
#     expect_success()
# })

# test_that("using empty conda fails", {
#   import_pySCA_module_using_reticulate(condaenv = "r-pySCA") %>%
#     expect_error()
# })

# test_that("installing conda-env works", {
#   import_pySCA_module_using_reticulate(
#     condaenv = "r-pySCA",force_installing = TRUE) %>%
#     testthat::expect_success()
# })
#
# test_that("not empty conda-env works", {
#   import_pySCA_module_using_reticulate(condaenv = "r-pySCA") %>%
#     expect_success()
# })
#
# test_that("using both works", {
#   import_pySCA_module_using_reticulate(
#     virtualenv = "r-pySCA", condaenv = "r-pySCA",force_installing = TRUE) %>%
#     testthat::expect_success()
# })
