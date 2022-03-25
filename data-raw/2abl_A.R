## code to prepare `2abl_A` dataset goes here

library(toolkit4pySCA)
library(Biostrings)
library(xml2)
library(magrittr)
progressr::handlers(global = TRUE)

db <- c("swissprot", "pdb")
# >2abl_A mol:protein length:163  ABL TYROSINE KINASE
example.seq <- AAString(
  paste0("MGPSENDPNLFVALYDFVASGDNTLSITKGEKLRVLGYNHNGEWCEAQTKNGQGWVPSNYITPVNSLE",
         "KHSWYHGPVSRNAAEYLLSSGINGSFLVRESESSPGQRSISLRYEGRVYHYRINTASDGKLYVSSESRFNTLAELV",
         "HHHSTVADGLITTLHYPAP")
)


#xml.file.path.pdb <- system.file("extdata", "2abl_A_pdb.xml", package = "toolkit4pySCA")

#df.phmmer <- quick_AA_search_using_phmmer(example.seq, db)

# xml.files <-df.phmmer %$%
#     purrr::map2_chr(seqdb, xml_format, ~{
#       path_xml <- paste0("inst/extdata/2abl_A_", .x, ".xml")
#       read_xml(.y) %>% write_xml(path_xml)
#       path_xml
#     })

# fullseq.fasta.files <-df.phmmer %$%
#     purrr::map2_chr(seqdb, fullfasta_format, ~{
#       path_fasta <- paste0("inst/extdata/2abl_A_", .x, "fullseq.fa")
#       readAAStringSet(.y) %>% writeXStringSet(path_fasta)
#       path_fasta
#     })
path <- "inst/extdata/"
xml.files <- purrr::map_chr(dir(path, pattern = "*.xml"), ~paste0(path, .x))
fullseq.fasta.files <- purrr::map_chr(dir(path, pattern = "*fullseq.fa"), ~paste0(path, .x))
fasta.files <- readAAStringSet(fullseq.fasta.files)
df.phmmer.info <- xml.files %>%
  purrr::map_dfr(
    ~read_xml(.x) %>%
      extract_tidy_df_from_hmmer,
    .id = "db")
phmmer_2abl_A <- list("df" = df.phmmer.info, "fullfasta" = fasta.files)
usethis::use_data(phmmer_2abl_A, overwrite = FALSE)
