#' post_request_to_phmer
#'
#' @param body_list A list with body parameters for the POST request.
#'
#' @return A URL with the results.
#' @export
#'
#' @examples
#' \dontrun{
#' post_request_to_phmer(body_list =
#'     list(seqdb = "pdb",seq = '>Seq\nKLRVLGYH'))
#' }
post_request_to_phmer <- function(body_list) {
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
    return(r_request$url)
}
