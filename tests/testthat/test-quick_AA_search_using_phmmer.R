test_that("quick AA search works", {
  seq <- "KLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAEY"
  quick_AA_search_using_phmmer(seq) %>%
    expect_error(NA)
})

test_that("search using nucleic acid fails", {
  seq <- "AATCCGCTAGAATCCGCTAGAATCCGCTAG"
  quick_AA_search_using_phmmer(seq) %>%
    expect_error()
})

test_that("quick AA search using Biostrings", {
  seq <- Biostrings::AAString(
  paste0("MGPSENDPNLFVALYDFVASGDNTLSITKGEKLRVLGYNHNGEWCEAQTKNGQGWVPSNYITPVNSLE",
  "KHSWYHGPVSRNAAEYLLSSGINGSFLVRESESSPGQRSISLRYEGRVYHYRINTASDGKLYVSSESRFNTLAELV",
  "HHHSTVADGLITTLHYPAP")
  )
  quick_AA_search_using_phmmer(seq) %>%
    expect_error(NA)
})
