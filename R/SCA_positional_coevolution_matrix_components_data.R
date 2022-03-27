#' It returns the independent components and the eigenmodes (PCA) of Csca.
#'
#' @param db Pickle pySCA
#'
#' @return Data Frame
#' @export
#'
SCA_positional_coevolution_matrix_components_data <- function(db){
  if(is.null(db$sector$Vsca))
    stop("'Vsca not found")
  if(is.null(db$sector$Vpica))
    stop("'Vpica not found")
  if(is.null(db$sector$kpos))
    stop("'kpos not found")
  kpos <- db$sector$kpos
  EVs <- db$sector$Vsca[1:kpos,] %>% t()
  colnames(EVs) <- paste0("V.", seq(kpos))
  ICs <- db$sector$Vpica
  colnames(ICs) <- paste0("V.", seq(kpos))
  EVs %>%
    tibble::as_tibble() %>%
    dplyr::mutate(mode = "eigenvalues")%>%
    dplyr::bind_rows(ICs %>%
      tibble::as_tibble() %>%
        dplyr::mutate(mode = "Principal.Components"))
}
