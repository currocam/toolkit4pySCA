if (requireNamespace("xml2", quietly = TRUE)) {
  test_that("example request works", {
    body <- list(
      seqdb = "pdb",
      seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAEY"
    )
    download_xml_from_phmer(body_list = body) %>%
      xml2::read_xml()%>%
      xml2::xml_find_all("//hits") %>%
      length(.) %>%
      expect_gt(0)
  })

  test_that("empty body fails", {
    body <- list()
    download_xml_from_phmer(body_list = body) %>%
      xml2::read_xml()%>%
      xml2::xml_find_all("//hits") %>%
      testthat::expect_error()
  })
  }

