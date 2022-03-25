skip_if_offline()
skip_if_not_installed("stringr")
testthat::skip_on_ci()
test_that("example request works", {
    body <- list(
      seqdb = "pdb",
      seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAEY"
    )
    post_request_to_phmer(body_list = body) %>%
      stringr::str_detect("hmmer/results") %>%
      testthat::expect_true()
  })

test_that("empty body fails", {
    body <- list()
    post_request_to_phmer(body_list = body) %>%
      testthat::expect_error()
  })


