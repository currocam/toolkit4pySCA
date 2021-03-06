#' extract_tidy_stats_from_xml
#'
#' @param xml.document A xml_document downloaded from HMMER that contain stats
#'
#' @return A tidy data.frame containing available stats' information in xml_document.
#' \itemize{
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
#' read_xml("2abl_A_pdb.xml") %>%
#'     extract_tidy_stats_from_xml()
#' }


extract_tidy_stats_from_xml <- function(xml.document){
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
    xml2::xml_find_all("//stats")%>%
    purrr::map(xml2::xml_attrs) %>%
    purrr::map_df(~as.list(.)) %>%
    tibble::as_tibble() %>%
    readr::type_convert()
}
