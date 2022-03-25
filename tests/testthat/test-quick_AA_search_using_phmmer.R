skip_if_offline()
skip_if_not_installed("Biostrings")
test_that("quick AA search works", {
  seq <- "KLRVLGYHNGEWCEAQTKNGQ"
  db <- "pdb"
  quick_AA_search_using_phmmer(seq, db) %>%
    dplyr::pull(results_url) %>%
    magrittr::extract2(1)%>%
    is.na(.) %>%
    testthat::expect_false()
})

test_that("quick AA search using ensembl works", {
  seq <- "KLRVLGYHNGEWCEAQTKNGQ"
  db <- "ensembl"
  quick_AA_search_using_phmmer(seq, db)  %>%
    dplyr::pull(results_url) %>%
    magrittr::extract2(1)%>%
    is.na(.) %>%
    testthat::expect_false()
})

test_that("search using nucleic acid fails", {
  seq <- "AATCCGCTAGAATCCGCTAGAATCCGCTAG"
  db <- "pdb"
  quick_AA_search_using_phmmer(seq, db)  %>%
    dplyr::pull(results_url) %>%
    magrittr::extract2(1)%>%
    is.na(.) %>%
    testthat::expect_true()
})

test_that("quick AA search using Biostrings", {
  seq <- Biostrings::AAStringSet(
  c("MGPSENDPNLFVALYDFVASGDNTLSI",
  "KLRVLGYHNGEWCEAQTKNGQ")
  )
  db <- c("pdb", "swissprot")
  quick_AA_search_using_phmmer(seq, db) %>%
    length() %>%
    testthat::expect_gt(0)
})

