#' quick_AA_search_using_phmmer
#'
#' @param seq A string of an AA sequence
#' @param seqdb A string of target database.

#'
#' @return A xml_document containig the results from phmmer.
#' @export
#'
#' @examples
#' \dontrun{
#' xml.document <- get_phmer_results_from_seq("DPNLFVALYDFVASGDNTLSIT", "pdb")
#' }
quick_AA_search_using_phmmer <- function(seq, seqdb){
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
        seqdb = seqdb,seq = seq)
    ) %>%
      return()
}
