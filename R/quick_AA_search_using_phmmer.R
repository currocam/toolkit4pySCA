#' quick_AA_search_using_phmmer
#'
#' @param seqaa A character vector with AA sequences
#' @param seqdb A character vector with target databases.

#'
#' @return A df containing url's for downloading different files.
#' @export
#'
#' @examples
#' \dontrun{
#' xml.document <- get_phmer_results_from_seq("DPNLFVALYDFVASGDNTLSIT", "pdb")
#' }
#' @importFrom rlang .data
quick_AA_search_using_phmmer <- function(seqaa, seqdb){
  if (!requireNamespace("progressr", quietly = TRUE)) {
    stop(
      "Package \"progressr\" must be installed to use this function.",
      call. = FALSE
    )
  }
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
  seqaa <- as.character(seqaa)
  if(! seqaa %>%
        stringr::str_extract_all(
          stringr::boundary("character")
        ) %>%
        unlist() %in% Biostrings::AA_ALPHABET %>%
        all()
     )
      stop("'seq' should be a protein sequence")
  #all combinations of inputs
  df <- tidyr::expand_grid(seqaa, seqdb)
  p <- progressr::progressor(steps = length(df))
  urls <- purrr::map2_chr(df$seqaa, df$seqdb,
    purrr::possibly(
      ~{
      body_list <- list(seq = .x, seqdb = .y)
      url <- post_request_to_phmer(body_list)
      p()
      url
      },
    otherwise = NA)
  )
  HMMER_RESULTS <- "https://www.ebi.ac.uk/Tools/hmmer/results/"
  HMMER_DOWNLOAD <- "https://www.ebi.ac.uk/Tools/hmmer/download/"
  HMMER_SUFFIX <- "/score?format="
  df %>%
    dplyr::mutate(
      results_url = urls,
      id = .data$results_url %>%
        stringr::str_remove(HMMER_RESULTS) %>%
        stringr::str_remove("/score"),
      text_format = paste0(HMMER_DOWNLOAD, .data$id, HMMER_SUFFIX, "text"),
      tab_format = paste0(HMMER_DOWNLOAD, .data$id, HMMER_SUFFIX, "tsv"),
      xml_format = paste0(HMMER_DOWNLOAD, .data$id, HMMER_SUFFIX, "xml"),
      json_format = paste0(HMMER_DOWNLOAD, .data$id, HMMER_SUFFIX, "json"),
      fasta_format = paste0(HMMER_DOWNLOAD, .data$id, HMMER_SUFFIX, "fasta"),
      fullfasta_format = paste0(HMMER_DOWNLOAD, .data$id, HMMER_SUFFIX, "fullfasta"),
      alignedfasta_format = paste0(HMMER_DOWNLOAD, .data$id, HMMER_SUFFIX, "afa"),
      stockholm_format = paste0(HMMER_DOWNLOAD, .data$id, HMMER_SUFFIX, "stockholm"),
      clustalw_format = paste0(HMMER_DOWNLOAD, .data$id, HMMER_SUFFIX, "clu"),
      psi_blast_format = paste0(HMMER_DOWNLOAD, .data$id, HMMER_SUFFIX, "psi"),
      phylip_format = paste0(HMMER_DOWNLOAD, .data$id, HMMER_SUFFIX, "phy"),
  )
  }

