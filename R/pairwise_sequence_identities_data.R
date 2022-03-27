#' It computes the data from the simmilarity matrix in order to visualize
#'    the pairwise sequence identities
#'
#' @param db Pickle pySCA
#'
#' @return Tidy DataFrame
#' @export
#'
pairwise_sequence_identities_data <- function(db){
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
  simMat[lower.tri(simMat)] <- NA
  simMat%>%
    as.data.frame() %>%
    magrittr::set_colnames(headers) %>%
    dplyr::mutate(seq.1 = headers)%>%
    tidyr::pivot_longer(- c("seq.1"),
                        names_to = "seq.2",
                        values_to = "simmilarity") %>%
    tidyr::drop_na()
}


#' Plot a histogram of all pairwise sequence identities
#'
#' @param db Pickle pySCA
#'
#' @export
pairwise_sequence_identities_hist <- function(db) {
  plot_data <- pairwise_sequence_identities_data(db)
  ggplot2::ggplot(plot_data, ggplot2::aes(.data$simmilarity)) +
    ggplot2::geom_histogram(binwidth=0.01, color="#e9ecef", alpha=0.9) +
    ggplot2::labs(x = "Pairwise sequence identities", y = "Number")
}
