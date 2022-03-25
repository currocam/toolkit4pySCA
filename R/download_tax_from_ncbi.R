#' Create a dataframe with taxonomic information extracted from NCBI.
#'
#' @param taxid A character vector containing Uniprot taxonomy id
#' @param rank_vc A character vector containing Taxonomic rank columns
#'
#' @return Dataframe
#' @export
#' @examples
#' \dontrun{
#' #sequential
#' download_xml_from_phmer(body_list =
#'     list(seqdb = "pdb",seq = '>Seq\nKLRVLGYH'))
#' }
download_tax_from_ncbi <- function(taxid,
  rank_vc = c("superkingdom", "kingdom","phylum", "subphylum","superclass",
    "class","suborder",  "order","family","subfamily","genus","species")) {
  if (!requireNamespace("progressr", quietly = TRUE)) {
    stop(
      "Package \"progressr\" must be installed to use this function.",
      call. = FALSE
    )
  }
  if (!requireNamespace("taxizedb", quietly = TRUE)) {
    stop(
      "Package \"taxizedb\" must be installed to use this function.",
      call. = FALSE
    )
  }
  taxid <- as.numeric(unique(taxid))
  p <- progressr::progressor(steps = length(taxid))
  ## Check arguments
  if(!is.character(rank_vc))
    stop("'rank_vc' should be character")

  tax_cl <- taxizedb::classification(taxid) %>%
    purrr::discard(~ any(is.na(.x)))
  furrr::future_map2_dfr(tax_cl, names(tax_cl), ~{
    p()
    dplyr::filter(.x, rank %in% rank_vc) %>%
      dplyr::distinct(rank, .keep_all = TRUE) %>%
      dplyr::select(name, rank) %>%
      dplyr::mutate(taxid = .y)%>%
      tidyr::pivot_wider(names_from = rank, values_from = name)
    }) %>%
  tibble::as_tibble()
}
