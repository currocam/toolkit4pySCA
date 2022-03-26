#' phmmer_HBG2_HUMAN
#'
#'
#' A list containing the results of 200 entries after searching HBG2_HUMAN sequence
#' in phmmer against PDB and SwissProt, then preparing the results to perform 
#' statistical coupling analyses using pySCA.
#'
#' A list containing the following items:
#' \itemize{
#' \item{df: a data frame with 1029 rows and 78 columns. It contains the results
#' of searching with phmmer against PDB and SwissProt. It has as many entries as
#'  domains have been identified and is intended to make use of the `group_by`
#'  function, in order to access information related to the hash 'stats' and
#'   'sequences'. To understand the meaning of the columns, see
#'  \code{\link{extract_tidy_df_from_hmmer}} }
#' \item{fullfasta: An AAStringSet from the Biostrings library containing all
#'  completed sequences found with phmmer. It is intended to be filtered for
#'  redundancy using unique() and with df-related information (e.g. e-value)
#'  using [] indexes.}
#'  \item{aln: An MsaAAMultipleAlignment of non-redundant sequences whose
#'   e-value and the best e-value of their domains was less than 0.001. The
#'    alignment was performed using msaClustalW. }
#' }
#'
#' @source \url{http://hmmer.org/}
"phmmer_HBG2_HUMAN"
