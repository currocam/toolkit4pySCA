#' SCA correlation matrix data
#'
#' @param db Pickle pySCA
#'
#' @return Data Frame
#' @export
#'
SCA_correlation_matrix_data <- function(db){
  if(is.null(db$sca$Csca))
    stop("'Csca not found")
  if(is.null(db$sequence$Npos))
    stop("'Npos not found")
  if(nrow(db$sca$Di) != db$sequence$Npos)
    stop("'Csca and Npos do not agree in length")
  AA.position <- seq(db$sequence$Npos)
  Csca <- db$sca$Csca
  rownames(Csca) <- AA.position
  colnames(Csca) <- AA.position
  Csca
}
