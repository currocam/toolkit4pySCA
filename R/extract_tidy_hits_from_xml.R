#' extract_tidy_hits_from_xml
#'
#' @param xml.document A xml_document downloaded from HMMER that contain hits.
#'
#' @return A tidy data.frame containing available hits' information in xml_document.
#'
#' \itemize{
#' \item {name: Name of the target (sequence for phmmer/hmmsearch, HMM for hmmscan)}
#' \item {acc: Accession of the target}
#' \item {acc2: Secondary accession of the target}
#' \item {id: Identifier of the target}
#' \item {desc: Description of the target}
#' \item {score: Bit score of the sequence (all domains, without correction)}
#' \item {pvalue: P-value of the score}
#' \item {evalue: E-value of the score}
#' \item {nregions: Number of regions evaluated}
#' \item {nenvelopes: Number of envelopes handed over for domain definition, null2, alignment, and scoring.}
#' \item {ndom: Total number of domains identified in this sequence}
#' \item {nreported: Number of domains satisfying reporting thresholding}
#' \item {nregions: Number of regions evaluated}
#' \item {nincluded: Number of domains satisfying inclusion thresholding}
#' \item {taxid: The NCBI taxonomy identifier of the target (if applicable)}
#' \item {species: The species name of the target (if applicable)}
#' \item {kg: The kingdom of life that the target belongs to - based on placing in the NCBI taxonomy tree (if applicable)}
#' \item {seqs: 	An array containing information about the 100% redundant sequences}
#' \item {pdbs: Array of pdb identifiers (which chains information)}
#' }
#'
#' @export
#' @examples
#' \dontrun{
#' read_xml("2abl_A_pdb.xml") %>%
#'     extract_tidy_hits_from_xml()
#' }
extract_tidy_hits_from_xml <- function(xml.document){
  if (!requireNamespace("purrr", quietly = TRUE)) {
    stop(
      "Package \"purrr\" must be installed to use this function.",
      call. = FALSE
    )
  }

  if (!requireNamespace("xml2", quietly = TRUE)) {
    stop(
      "Package \"xml2\" must be installed to use this function.",
      call. = FALSE
    )
  }

  if(! "xml_document" %in% class(xml.document))
    stop("'xml.document' should be a xml.document")

  xml.document %>%
    xml2::xml_find_all("//hits")%>%
    purrr::map(xml2::xml_attrs) %>%
    purrr::map_df(~as.list(.)) %>%
    tibble::as_tibble()%>%
    readr::type_convert()
}


