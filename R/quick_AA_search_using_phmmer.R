#' quick_AA_search_using_phmmer
#'
#' @param seq An aminocid sequence
#'
#' @return A xml_document containig the results from phmmer.
#' @export
#'
#' @examples
#' \dontrun{
#' xml.document <- get_phmer_results_from_seq("DPNLFVALYDFVASGDNTLSIT")
#' }
quick_AA_search_using_phmmer <- function(seq){
  seq <- as.character(seq)
  if (!requireNamespace("Biostrings", quietly = TRUE)) {
    stop(
      "Package \"Biostrings\" must be installed to use this function.",
      call. = FALSE
      )
  }

  if (!requireNamespace("xml2", quietly = TRUE)) {
      stop(
        "Package \"xml2\" must be installed to use this function.",
        call. = FALSE
      )
  }
  if (!requireNamespace("stringr", quietly = TRUE)) {
    stop(
      "Package \"stringr\" must be installed to use this function.",
      call. = FALSE
    )
  }
  if(! seq %>%
        stringr::str_extract_all(
          stringr::boundary("character")
        ) %>%
        unlist() %in% Biostrings::AA_ALPHABET %>%
        all()
     )
      stop("'seq' should be a protein sequence")

  download_xml_from_phmer(
      body_list = list(
        seqdb = "pdb",seq = seq)
    ) %>%
      xml2::read_xml() %>%
      magrittr::extract2(1)%>%
      return()
}
