#' extract_tidy_domains_from_xml
#'
#' @param xml.document A xml_document downloaded from HMMER.
#'
#' @return A tidy data.frame containing available domains' information in xml_document.
#' \itemize{
#' \item{ienv}{Envelope start position}
#' \item{jenv}{Envelope end position}
#' \item{iali}{Alignment start position}
#' \item{jali}{Alignment end position}
#' \item{bias}{null2 score contribution}
#' \item{oasc}{TOptimal alignment accuracy score}
#' \item{bitscore}{Overall score in bits, null corrected, if this were the only domain in seq}
#' \item{cevalue}{Conditional E-value based on the domain correction}
#' \item{ievalue}{Independent E-value based on the domain correction}
#' \item{is_reported}{1 if domain meets reporting thresholds}
#' \item{is_included}{1 if domain meets inclusion thresholds}
#' \item{alimodel}{Aligned query consensus sequence phmmer and hmmsearch, target hmm for hmmscan}
#' \item{alimline}{Match line indicating identities, conservation +’s, gaps}
#' \item{aliaseq}{Aligned target sequence for phmmer and hmmsearch, query for hmmscan}
#' \item{alippline}{Posterior probability annotation}
#' \item{alihmmname}{Name of HMM (query sequence for phmmer, alignment for hmmsearch and target hmm for hmmscan)}
#' \item{alihmmacc}{Accession of HMM}
#' \item{alihmmdesc}{Description of HMM}
#' \item{alihmmfrom}{Start position on HMM}
#' \item{alihmmto}{End position on HMM}
#' \item{aliM}{Length of model}
#' \item{alisqname}{Name of target sequence (phmmer, hmmscan) or query sequence(hmmscan)}
#' \item{alisqacc}{Accession of sequence}
#' \item{alisqdesc}{Description of sequence}
#' \item{alisqfrom}{Start position on sequence}
#' \item{alisqto}{End position on sequence}
#' \item{aliL}{Length of sequence}
#'}
#'
#' @export
#'
#' @examples
#' \dontrun{
#'  xml.path %>%
#'    read_xml() %>%
#'    extract_tidy_domains_from_xml()
#' }
extract_tidy_domains_from_xml <- function(xml.document){
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
    xml2::xml_find_all("//domains")%>%
    purrr::map(xml2::xml_attrs) %>%
    purrr::map_df(~as.list(.)) %>%
    tibble::as_tibble() %>%
    readr::type_convert()
}
