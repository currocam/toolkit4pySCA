## code to prepare `DATASET` dataset goes here

library(toolkit4pySCA)
library(Biostrings)
library(xml2)

db <- "pdb"
# >2abl_A mol:protein length:163  ABL TYROSINE KINASE
example.seq <- AAString(
  paste0("MGPSENDPNLFVALYDFVASGDNTLSITKGEKLRVLGYNHNGEWCEAQTKNGQGWVPSNYITPVNSLE",
         "KHSWYHGPVSRNAAEYLLSSGINGSFLVRESESSPGQRSISLRYEGRVYHYRINTASDGKLYVSSESRFNTLAELV",
         "HHHSTVADGLITTLHYPAP")
)

xml.file.path.pdb <- system.file("extdata", "2abl_A_pdb.xml", package = "toolkit4pySCA")
if (xml.file.path.pdb == "") {
  raw.xml <- quick_AA_search_using_phmmer(example.seq, db)
  raw.xml %>%
    read_xml() %>%
    write_xml(xml.document,file = "inst/extdata/2abl_A_pdb.xml")
  xml.file.path.pdb <- system.file("extdata", "2abl_A_pdb.xml", package = "toolkit4pySCA")

}
xml.document.pdb <- read_xml(xml.file.path.pdb)

xml.file.path.swissprot <- system.file("extdata", "2abl_A_swissprot.xml", package = "toolkit4pySCA")
db <- "swissprot"
if (xml.file.path.swissprot == "") {
  raw.xml <- quick_AA_search_using_phmmer(example.seq, db)
  raw.xml %>%
    read_xml() %>%
    write_xml(xml.document,file = "inst/extdata/2abl_A_swissprot.xml")
  xml.file.path <- system.file("extdata", "2abl_A_swissprot.xml", package = "toolkit4pySCA")

}

xml.document.swissprot <- read_xml(xml.file.path.swissprot)

#usethis::use_data(DATASET, overwrite = TRUE)
