% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_sectors_for_pymol.R
\name{write_sectors_for_pymol}
\alias{write_sectors_for_pymol}
\title{Write a small script in pymol where you load the PDB file and define groups with the sectors.}
\usage{
write_sectors_for_pymol(
  db,
  fetch_pdb = NULL,
  pdb_path = "path_to_pdb",
  output_file
)
}
\arguments{
\item{db}{Pickle pySCA}

\item{fetch_pdb}{A character vector of one 4-letter PDB codes. If used, the PDB file will be downloaded when the script is run.}

\item{pdb_path}{A character vector of one, path to the pdb file}

\item{output_file}{A character vector of one, where the script will be saved.}
}
\description{
Write a small script in pymol where you load the PDB file and define groups with the sectors.
}
