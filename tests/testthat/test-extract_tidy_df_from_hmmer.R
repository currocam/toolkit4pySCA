test_that("extract tidy df with pdb example", {
  xml2::read_xml("2abl_A_pdb.xml") %>%
    extract_tidy_df_from_hmmer() %>%
    expect_s3_class("tbl_df")
})
test_that("extract tidy df with swissprot example", {
  xml2::read_xml("2abl_A_swissprot.xml") %>%
    extract_tidy_df_from_hmmer() %>%
    expect_s3_class("tbl_df")
})
