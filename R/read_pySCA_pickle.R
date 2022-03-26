#' Reads the pickle file produced by pySCA and returns a list of class pySCA_pickle.
#'
#' @param path Pat A character with the path file.
#'
#' @return pySCA_pickle
#' @export
#'
#' @examples
#' \dontrun{
#' pysca <- import_pySCA_module_using_reticulate( virtualenv = "r-pySCA", force_installing = FALSE)
#' path <- "inst/extdata/HBG2_HUMAN.ClustalW.db"
#' pySCA_HBG2_HUMAN <- read_pySCA_pickle(path)
#' }

read_pySCA_pickle <- function(path){
  if(!exists("pysca"))
    stop("'The pysca module could not be found. Please call the import_pySCA_module_using_reticulate function first.")

  db <- reticulate::py_load_object(path, pickle = "pickle")
  return(structure(db, class = "pySCA_pickle"))
  }
