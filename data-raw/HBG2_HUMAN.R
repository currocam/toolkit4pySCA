## code to prepare `HBG2_HUMAN` dataset goes here

library(toolkit4pySCA)
library(Biostrings)
library(xml2)
library(magrittr)
library(dplyr)
library(tidyr)
progressr::handlers(global = TRUE)

db <- c("swissprot", "pdb")


# >sp|P69892|HBG2_HUMAN Hemoglobin subunit gamma-2 OS=Homo sapiens OX=9606 GN=HBG2 PE=1 SV=2
example.seq <- AAString(
  paste0("MGHFTEEDKATITSLWGKVNVEDAGGETLGRLLVVYPWTQRFFDSFGNLSSASAIMGNPK",
         "VKAHGKKVLTSLGDAIKHLDDLKGTFAQLSELHCDKLHVDPENFKLLGNVLVTVLAIHFG",
         "KEFTPEVQASWQKMVTGVASALSSRYH")
)


df.phmmer <- quick_AA_search_using_phmmer(example.seq, db)

xml.files <-df.phmmer %$%
  purrr::map2_chr(seqdb, xml_format, ~{
    path_xml <- paste0("inst/extdata/HBG2_HUMAN", .x, ".xml")
    read_xml(.y) %>% write_xml(path_xml)
    path_xml
  })

fullseq.fasta.files <-df.phmmer %$%
  purrr::map2_chr(seqdb, fullfasta_format, ~{
    path_fasta <- paste0("inst/extdata/HBG2_HUMAN", .x, "fullseq.fa")
    readAAStringSet(.y) %>% writeXStringSet(path_fasta)
    path_fasta
  })

path <- "inst/extdata/"
xml.files <- purrr::map_chr(dir(path, pattern = "*.xml"), ~paste0(path, .x))
fullseq.fasta.files <- purrr::map_chr(dir(path, pattern = "*fullseq.fa"), ~paste0(path, .x))
fasta.files <- readAAStringSet(fullseq.fasta.files)
df.HBG2_HUMAN <- xml.files %>%
  purrr::map_dfr(
    ~read_xml(.x) %>%
      extract_tidy_df_from_hmmer,
    .id = "db")
#Sampling
unique.fasta <- fasta.files %>%
  unique() %>%
  names()

df.HBG2_HUMAN <- df.HBG2_HUMAN %>%
  filter(alisqacc %in% unique.fasta) %>%
  group_by(alisqacc) %>%
  mutate(bestDomainEvalue = max(ievalue)) %>%
  filter(bestDomainEvalue < 0.001) %>%
  select(-bestDomainEvalue) %>%
  nest() %>%
  ungroup() %>%
  slice_sample(n = 200) %>%
  unnest(cols = c(data))

fasta.files.filtered <- fasta.files[df.HBG2_HUMAN$alisqacc]

phmmer_HBG2_HUMAN <- list("df" = df.HBG2_HUMAN,
                          "fullfasta" = fasta.files.filtered)

myClustalWAlignment <- msa::msaClustalW(phmmer_HBG2_HUMAN$fullfasta)

myClustalWAlignment %>%
  unmasked() %>%
  writeXStringSet("inst/extdata/HBG2_HUMAN.ClustalW.aln")
phmmer_HBG2_HUMAN <- append(phmmer_HBG2_HUMAN, list("aln" = myClustalWAlignment))
usethis::use_data(phmmer_HBG2_HUMAN, overwrite = TRUE)

pysca <- import_pySCA_module_using_reticulate(
  virtualenv = "r-pySCA", force_installing = FALSE)

path <- "inst/extdata/HBG2_HUMAN.ClustalW.db"
pySCA_HBG2_HUMAN <- read_pySCA_pickle(path)

usethis::use_data(pySCA_HBG2_HUMAN, overwrite = TRUE)

db <-pySCA_HBG2_HUMAN
  db %>% toolkit4pySCA::eigenspectrum_SCA_positional_coevolution_matrix_plot()
