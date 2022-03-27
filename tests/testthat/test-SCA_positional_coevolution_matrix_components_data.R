test_that("it works", {
  db <- pySCA_HBG2_HUMAN
  db %>%
    SCA_positional_coevolution_matrix_components_data() %>%
    expect_s3_class("tbl_df")
})
