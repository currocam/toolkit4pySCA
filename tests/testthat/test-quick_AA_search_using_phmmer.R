test_that("quick AA search works", {
  seq <- "KLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAEY"
  db <- "pdb"
  quick_AA_search_using_phmmer(seq, db) %>%
    expect_error(NA)
})

test_that("quick AA search using ensembl works", {
  seq <- "KLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAEY"
  db <- "ensembl"
  quick_AA_search_using_phmmer(seq, db) %>%
    expect_error(NA)
})

test_that("search using nucleic acid fails", {
  seq <- "AATCCGCTAGAATCCGCTAGAATCCGCTAG"
  db <- "pdb"
  quick_AA_search_using_phmmer(seq, db) %>%
    expect_error()
})

test_that("quick AA search using Biostrings", {
  seq <- Biostrings::AAString(
  paste0("MGPSENDPNLFVALYDFVASGDNTLSITKGEKLRVLGYNHNGEWCEAQTKNGQGWVPSNYITPVNSLE",
  "KHSWYHGPVSRNAAEYLLSSGINGSFLVRESESSPGQRSISLRYEGRVYHYRINTASDGKLYVSSESRFNTLAELV",
  "HHHSTVADGLITTLHYPAP")
  )
  db <- "pdb"
  quick_AA_search_using_phmmer(seq, db) %>%
    expect_error(NA)
})
