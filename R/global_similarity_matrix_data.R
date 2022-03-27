#' It computes the data from the similarity matriz in order to visualize it.
#'
#' @param db Pickle pySCA
#'
#' @return Tidy DataFrame
#' @export
#'
global_similarity_matrix_data <- function(db){
  if(is.null(db$sca$simMat))
    stop("'simMat not found")
  simMat <- db$sca$simMat
  if(is.null(db$sequence$hd))
    stop("'Sequence headers not found")
  headers <- db$sequence$hd
  if(length(headers) != length(unique(headers))){
    headers <- make.unique(headers)
    warning("Sequence headers are not unique, make.unique has been used")
  }
  rownames(simMat) <- headers
  colnames(simMat) <- headers
  return(simMat)
}

#' Plot a heatmap in order to visualize
#'    global view of the sequence similarity matrix
#'
#' @param db Pickle pySCA
#'
#' @export
global_similarity_matrix_heatmap <- function(db) {
  plot_data <- toolkit4pySCA::global_similarity_matrix_data(db)
  return(stats::heatmap(plot_data, labRow=FALSE, labCol = FALSE))
}
