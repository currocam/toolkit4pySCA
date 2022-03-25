#' extract_tidy_df_from_hmmer
#'
#' @param xml.document A xml_document downloaded from HMMER
#' @param by_column A character vector for joining domains hash with sequence's hits hash.
#'
#' @return
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
