#' Write a small script in pymol where you load the PDB file and define groups with the sectors.
#'
#' @param db Pickle pySCA
#' @param fetch_pdb A character vector of one 4-letter PDB codes. If used, the PDB file will be downloaded when the script is run.
#' @param pdb_path A character vector of one, path to the pdb file
#' @param output_file A character vector of one, where the script will be saved.
#'
#' @export
#'
write_sectors_for_pymol <- function(db, fetch_pdb = NULL, pdb_path = "path_to_pdb", output_file){
  if(is.null(db$sector$ics_tidy_df))
    stop("'ics_tidy_df not found")
  sectors <- db$sector$ics_tidy_df %>%
    dplyr::select(.data$items, .data$ics)
  script <- c("#Sectors usin pySCA")
  if (!is.null(fetch_pdb)) {
    script <- append(script,
      paste0("fetch ", fetch_pdb))
  } else{
    script <- append(script,
    paste0("load ", pdb_path))
  }
  script <- append(script, "hide all")
  sectors <- sectors %>%
    dplyr::group_by(.data$ics) %>%
    dplyr::mutate(selection = paste0(.data$items, collapse = "+"))

  selection <-purrr::map2_chr(unique(sectors$ics),
    unique(sectors$selection),
    ~{paste0("select ",
           .x,
           ", resi ",
           .y)})
  script <- append(script, selection)
  script <- append(script, "as cartoon")
  write(script, output_file)
}
