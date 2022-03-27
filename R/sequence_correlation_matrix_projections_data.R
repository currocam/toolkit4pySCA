#' It computes the data from the PCA and IC and creates a tidy DataFrame
#'  in order to visualize the projections of the sequence correlation matrix.
#'
#' @param db Pickle pySCA
#'
#' @return Data Frame
#' @export
#'
sequence_correlation_matrix_projections_data <- function(db){
  if(is.null(db$sequence$seqw))
    stop("'sequence weights not found")
  if(is.null(db$sequence$hd))
    stop("'Sequence headers not found")
  headers <- db$sequence$hd
  if(length(headers) != length(unique(headers))){
    headers <- make.unique(headers)
    warning("Sequence headers are not unique, make.unique has been used")
  }
  if(is.null(db$sca$Useq))
    stop("'Useq not found")
  if(is.null(db$sca$Uica))
    stop("'Uica not found")
  seq.weigths <- db$sequence$seqw %>%
    as.numeric()
  eigenmodes <- db$sca$Useq %>%
    purrr::map2_dfr(
      c("no weight", "sequence weights", "sequence weights & positional weights"),
      ~ .x %>%
        as.data.frame() %>%
        dplyr::mutate(
          hd = headers,
          type.projections = .y,
               mode = "PCA", sequence.weights = seq.weigths)
    )
  independent <- db$sca$Uica %>%
    purrr::map2_dfr(
      c("no weight", "sequence weights", "sequence weights & positional weights"),
      ~ .x %>%
        as.data.frame() %>%
        dplyr::mutate(
              hd = headers,
              type.projections = .y,
              mode = "ICA", sequence.weights = seq.weigths)
    )
  eigenmodes %>%
    dplyr::bind_rows(independent)
}


#' Plot a facet grid projection
#'
#' @param db Pickle pySCA
#'
#' @export

sequence_correlation_matrix_projections_plot <- function(db) {
  plot_data <- toolkit4pySCA::sequence_correlation_matrix_projections_data(db)
  ggplot2::ggplot(plot_data, ggplot2::aes(x=.data$V1, y=.data$V2)) +
    ggplot2::geom_point(ggplot2::aes(colour = .data$sequence.weights, alpha = 0.5)) +
    ggplot2::labs(x = "V1", y = "V2")+
    ggplot2::facet_grid(.data$type.projections ~ .data$mode, scales = "free")+
    ggplot2::ggtitle("Projections of the sequence correlation matrix ")
}
