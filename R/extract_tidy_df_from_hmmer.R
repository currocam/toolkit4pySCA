#' Extract a tidy data frame with the hmmer results.
#'
#' @param xml.document A xml_document downloaded from HMMER
#' @param by_column A character vector for joining domains hash with
#'  sequence's hits hash. By default, it is
#'  \code{c("alisqacc" = "acc", "alisqname" = "name")}, i.e. use to match
#'  the results the acc and the names of the sequences. This is the one that
#'   should be used in most cases.
#'
#' @return DataFrame
#'
#' @details
#' Below, we list the meaning of the different columns following the HMMER documentation.
#' \itemize{
#' \item{ienv: Envelope start position}
#' \item{jenv: Envelope end position}
#' \item{iali: Alignment start position}
#' \item{jali: Alignment end position}
#' \item{bias: null2 score contribution}
#' \item{oasc: TOptimal alignment accuracy score}
#' \item{bitscore: Overall score in bits, null corrected, if this were the only domain in seq}
#' \item{cevalue: Conditional E-value based on the domain correction}
#' \item{ievalue: Independent E-value based on the domain correction}
#' \item{is_reported: 1 if domain meets reporting thresholds}
#' \item{is_included: 1 if domain meets inclusion thresholds}
#' \item{alimodel: Aligned query consensus sequence phmmer and hmmsearch, target hmm for hmmscan}
#' \item{alimline: Match line indicating identities, conservation +’s, gaps}
#' \item{aliaseq: Aligned target sequence for phmmer and hmmsearch, query for hmmscan}
#' \item{alippline: Posterior probability annotation}
#' \item{alihmmname: Name of HMM (query sequence for phmmer, alignment for hmmsearch and target hmm for hmmscan)}
#' \item{alihmmacc: Accession of HMM}
#' \item{alihmmdesc: Description of HMM}
#' \item{alihmmfrom: Start position on HMM}
#' \item{alihmmto: End position on HMM}
#' \item{aliM: Length of model}
#' \item{alisqname: Name of target sequence (phmmer, hmmscan) or query sequence(hmmscan)}
#' \item{alisqacc: Accession of sequence}
#' \item{alisqdesc: Description of sequence}
#' \item{alisqfrom: Start position on sequence}
#' \item{alisqto: End position on sequence}
#' \item{aliL: Length of sequence}
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
#' \item{nhits: The number of hits found above reporting thresholds}
#' \item{Z: The number of sequences or models in the target database}
#' \item{domZ: The number of hits in the target database}
#' \item{nmodels: The number of models in this search}
#' \item{nincluded: The number of sequences or models scoring above the significance threshold}
#' \item{nreported: The number of sequences or models scoring above the reporting threshold}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#'  xml.path %>%
#'    read_xml() %>%
#'    extract_tidy_df_from_hmmer()
#' }

extract_tidy_df_from_hmmer <- function(xml.document, by_column = c("alisqacc" = "acc", "alisqname" = "name")){
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

  hits <- xml.document %>%
        extract_tidy_hits_from_xml() %>%
    dplyr::rename(c("nincluded_domains" = "nincluded",
                    "nreported_domains" = "nreported"))
  stats <- xml.document %>%
    extract_tidy_stats_from_xml() %>%
    dplyr::rename(c("nincluded_sequences_or_models" = "nincluded",
                    "nreported_sequences_or_models" = "nreported"))
  domains <- xml.document %>%
    extract_tidy_domains_from_xml()
  domains %>%
    dplyr::left_join(hits,by = by_column) %>%
    dplyr::bind_cols(stats) %>%
    tibble::as_tibble()
}
