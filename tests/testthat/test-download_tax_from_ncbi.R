skip_if_offline()
skip_if_not_installed("taxizedb")

test_that("Danio rerio sequential, length one", {
  df <- download_tax_from_ncbi(7955, "species")
  df.check <- tibble::tibble(taxid = "7955", species = "Danio rerio")
  expect_identical(df, df.check)
})

test_that("Danio rerio & Phascolarctos cinereus sequential, length 2", {
  df <- download_tax_from_ncbi(c(7955, 38626), c("species", "phylum"))
  check <- c("Danio rerio", "Phascolarctos cinereus")
  df %>%
    dplyr::pull(species) %>%
    expect_setequal(check)
})

skip_if_not_installed("future")
test_that("Danio rerio & Phascolarctos cinereus parallel, length 2", {
  future::plan(future::multisession, workers = 2)
  df <- download_tax_from_ncbi(c(7955, 38626), c("species", "phylum"))
  check <- c("Danio rerio", "Phascolarctos cinereus")
  df %>%
    dplyr::pull(species) %>%
    expect_setequal(check)
})

test_that("Test is silent", {
  expect_silent(
    df <- download_tax_from_ncbi(c(7955, 38626), c("species", "phylum"))
  )
  future::plan(future::multisession, workers = 2)
  expect_silent(
  df <- download_tax_from_ncbi(c(7955, 38626), c("species", "phylum"))
  )
})

test_that("Progress bar", {
  expect_error(
    progressr::with_progress({
      df <- download_tax_from_ncbi(c(7955, 38626), c("species", "phylum"))
    }),
  NA)
})
