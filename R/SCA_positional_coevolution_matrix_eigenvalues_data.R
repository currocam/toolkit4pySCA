#' Eigenspectrum of the SCA positional coevolution matrix and 10 trials of matrix randomization for comparison
#'
#' @param db Pickle pySCA
#'
#' @return Data Frame
#' @export
#'
SCA_positional_coevolution_matrix_eigenvalues_data <- function(db){
  if(is.null(db$sector$Lsca))
    stop("'Lsca not found")
  if(is.null(db$sca$Lrand))
    stop("'Lrand not found")
  if(is.null(db$sca$Ntrials))
    stop("'Ntrials not found")
  Ntrials <- db$sca$Ntrials
  Lsca <- db$sector$Lsca %>%
    as.data.frame()# eigenvalues of the sca matrix
  colnames(Lsca) <- "Eigenvalues.ScaMatrix"

  lrand <- db$sca$Lrand  %>%# eigenvalues for the Cabij~
    t() %>%
    as.data.frame()
  colnames(lrand) <-  paste0("Eigenvalues.Randomized.Alignment.", seq(Ntrials))
  Lsca %>%
    dplyr::bind_cols(lrand) %>%
    tibble::as_tibble()
}

#' Plot the eigenspectrum of the SCA positional coevolution matrix (Cij~)
#' and 10 trials of matrix randomization for comparison. This graph is used
#'  to choose the number of significant eigenmodes
#'
#' @param db Pickle pySCA
#'
#' @export
eigenspectrum_SCA_positional_coevolution_matrix_plot <- function(db) {
  plot_data <- SCA_positional_coevolution_matrix_eigenvalues_data(db)
  if(is.null(db$sequence$Npos))
    stop("'Npos not found")
  if(is.null(db$sector$kpos))
    stop("'kpos not found")

  npos <- db$sequence$Npos
  Ntrials <- db$sca$Ntrials
  kpos <- db$sector$kpos

  random <- plot_data %>%
    dplyr::select(-c("Eigenvalues.ScaMatrix")) %>%
    purrr::flatten_dbl() %>%
    graphics::hist(breaks = npos, plot = FALSE)
  random.df <- tibble::tibble(
    breaks = random$breaks[-1],
    counts = random$counts/Ntrials)

  plot_data %>%
    ggplot2::ggplot(ggplot2::aes(.data$Eigenvalues.ScaMatrix))+
    ggplot2::geom_histogram(bins = npos, color="#e9ecef", alpha=0.9)+
    ggplot2::geom_line(data = random.df,
                       ggplot2::aes(x = .data$breaks, y = .data$counts),
                       color="red", alpha=0.9)+
    ggplot2::ggtitle(paste0("Eigenspectrum histogram of the SCA matrix and ",
                            as.character(Ntrials), " trials of matrix randomization"),
                     subtitle = paste0("Number of eigenmodes to keep is ", kpos))+
    ggplot2::xlab("Eigenvalues")+
    ggplot2::ylab("Numbers")
}

