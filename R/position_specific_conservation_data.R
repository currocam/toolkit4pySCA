#'  Position-specific conservation for each position
#'
#' @param db Pickle pySCA
#'
#' @return Data Frame
#' @export
#'
position_specific_conservation_data <- function(db){
  if(is.null(db$sca$Di))
    stop("'Di not found")
  if(is.null(db$sequence$Npos))
    stop("'Npos not found")
  if(length(db$sca$Di) != db$sequence$Npos)
    stop("'Di and Npos do not agree in length")
  tibble::tibble(
    Di = db$sca$Di,
    AA.position = seq(db$sequence$Npos)
  )
}

#' Plot the position-specific conservation values for each position.
#'
#' @param db Pickle pySCA
#'
#' @export

position_specific_conservation_plot <- function(db) {
  plot_data <- toolkit4pySCA::position_specific_conservation_data(db)
  ggplot2::ggplot(plot_data, ggplot2::aes(y=.data$Di, x=.data$AA.position)) +
    ggplot2::geom_bar(stat="identity") +
    ggplot2::labs(x = "'Amino acid position", y = "Di")+
    ggplot2::ggtitle("First-order statistics: position-specific conservation")
}
