#' download_xml_from_phmer
#'
#' @param body_list A list with body parameters for the POST request.
#'
#' @return A XML file in as raw.
#' @export
#'
#' @examples
#' \dontrun{
#' download_xml_from_phmer(body_list =
#'     list(seqdb = "pdb",seq = '>Seq\nKLRVLGYH'))
#' }
download_xml_from_phmer <- function(body_list) {
  if (!requireNamespace("httr", quietly = TRUE)) {
    stop(
      "Package \"httr\" must be installed to use this function.",
      call. = FALSE
    )
  }
  if(!is.list(body_list))
    stop("'body_list' should be a list")
  if(length(body_list) == 0)
    stop("'body_list' should greater than 0")

    # Function
    PHMER_URL <- "https://www.ebi.ac.uk/Tools/hmmer/search/phmmer"
    #post the seqrch request to the server
    r_request <- httr::POST(PHMER_URL,
          body = body_list)
    if(r_request$status_code == 400)
      stop("(HTTP) 400 Bad Request while posting the request to the server")

    #get the url where the results can be fetched from
    url <- r_request$url
    r_get <- httr::GET(url,
      config = httr::add_headers("Accept" = "application/xml"))

    if(r_get$status_code == 400)
      stop("(HTTP) 400 Bad Request while fetching the results")

    return(httr::content(r_get, as = "raw"))
}
