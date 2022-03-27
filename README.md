
<!-- README.md is generated from README.Rmd. Please edit that file -->

# toolkit4pySCA

<!-- badges: start -->

[![R-CMD-check](https://github.com/currocam/toolkit4pySCA/workflows/R-CMD-check/badge.svg)](https://github.com/currocam/toolkit4pySCA/actions)
<!-- badges: end -->

The objective of toolkit4pySCA is to provide a set of functions that
allow to obtain a sequence alignment using HMMER and to associate
taxonomic information to it. Then, it allows to read the file generated
by pySCA in R and to easily extract and analyze part of the information.

## Installation

You can install the development version of toolkit4pySCA from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("currocam/toolkit4pySCA")
```

## Example using HBG2_HUMAN

This is a basic example showing how to perform a typical workflow with
the HBG2_HUMAN sequence. First of all, we load the libraries, define an
AAString with the sequence of interest and indicate that, when possible,
we want progress bars to appear.

``` r
library(toolkit4pySCA)
library(Biostrings)
library(tidyverse)
library(kableExtra)
library(magrittr)
#progressr::handlers(global = TRUE)
# >sp|P69892|HBG2_HUMAN Hemoglobin subunit gamma-2 OS=Homo sapiens OX=9606 GN=HBG2 PE=1 SV=2
example.seq <- AAString(
  paste0("MGHFTEEDKATITSLWGKVNVEDAGGETLGRLLVVYPWTQRFFDSFGNLSSASAIMGNPK",
         "VKAHGKKVLTSLGDAIKHLDDLKGTFAQLSELHCDKLHVDPENFKLLGNVLVTVLAIHFG",
         "KEFTPEVQASWQKMVTGVASALSSRYH"
         ))
```

### Constructing and annotating a multiple sequence alignment

First, we will perform a search for sequences homologous to HBG2_HUMAN
using phmmer. We will use the `quick_AA_search_using_phmmer` function to
programmatically access hmmer. This function sends a request to HMMER
with the sequence of interest and the target database and returns a
DataFrame with the urls where to download the resulting files.

``` r
df.phmmer <- quick_AA_search_using_phmmer(
  seqaa = example.seq,
  seqdb = c("swissprot", "pdb"))
```

Using purrr’s map family of functions, we can download directly from R
the XML files (containing all the information related to the sequences)
and the fullseq-fasta files (containing the unaligned sequences).

``` r
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
```

The next function we are going to use from the library is the
`extract_tidy_df_from_hmmer` function. This function extracts the
information contained in the xml file and converts it into a sorted
DataFrame, thus facilitating further preprocessing. To read the fasta
files, we can make use of the `readAAStringSet` function of Biostrings.
We will, again, make use of the map family of functions to create a
single DataFrame.

``` r
fasta.files <- readAAStringSet(fullseq.fasta.files)
df.HBG2_HUMAN <- xml.files %>%
  purrr::map_dfr(
    ~ xml2::read_xml(.x) %>%
      extract_tidy_df_from_hmmer,
    .id = "db")
```

Now, we can explore the data obtained using R. For example, let’s look
at the taxonomic distribution and domain architecture.

``` r
df.HBG2_HUMAN %>%
  select(alisqacc, ph, arch) %>% #We select the phylo and the domain architecture.
  distinct(.keep_all = TRUE) %>% #We remove repeated rows (produced when ndom >1).
  ggplot(aes(y=ph, fill = arch)) + 
    geom_bar(stat = "count")
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" /> As
well as preprocessing them, we will filter out those sequences with a
significant evalue of \< 0.001, which belong to *Chordata* and whose
sequences are not redundant with each other.

``` r
#We create a vector with the names of the sequences we have filtered.
acc.filtered <- df.HBG2_HUMAN %>%
  filter(evalue < 0.001) %>%
  filter(ph == "Chordata") %>%
  pull(alisqacc)
#We select the sequences of the file that correspond and make sure that they are redundant. 
fasta.files.filtered <- fasta.files[acc.filtered] %>%
  unique()
```

Now, we can use the `download_tax_from_ncbi()` function to download the
taxonomic information associated with these sequences.

``` r
df.HBG2_HUMAN.ann <- df.HBG2_HUMAN %>%
  filter(alisqacc %in% names(fasta.files.filtered)) %>%# We choose non-redundant seq
  pull(taxid) %>%
  download_tax_from_ncbi() %>%
  mutate(taxid = as.numeric(taxid))%>%
  left_join(df.HBG2_HUMAN, by = c("taxid" = "taxid"))
#> Registered S3 method overwritten by 'hoardr':
#>   method           from
#>   print.cache_info httr
df.HBG2_HUMAN.ann %>%
  select(alisqacc, genus, desc) %>% 
  head() %>% kbl()
```

<table>
<thead>
<tr>
<th style="text-align:left;">
alisqacc
</th>
<th style="text-align:left;">
genus
</th>
<th style="text-align:left;">
desc
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
HBB_MELAE
</td>
<td style="text-align:left;">
Melanogrammus
</td>
<td style="text-align:left;">
Hemoglobin subunit beta
</td>
</tr>
<tr>
<td style="text-align:left;">
HBA3_XENTR
</td>
<td style="text-align:left;">
Xenopus
</td>
<td style="text-align:left;">
Hemoglobin subunit alpha-3
</td>
</tr>
<tr>
<td style="text-align:left;">
HBAT_PAPAN
</td>
<td style="text-align:left;">
Papio
</td>
<td style="text-align:left;">
Hemoglobin subunit theta-1
</td>
</tr>
<tr>
<td style="text-align:left;">
HBB_PAPAN
</td>
<td style="text-align:left;">
Papio
</td>
<td style="text-align:left;">
Hemoglobin subunit beta
</td>
</tr>
<tr>
<td style="text-align:left;">
HBBB_SERQU
</td>
<td style="text-align:left;">
Seriola
</td>
<td style="text-align:left;">
Hemoglobin subunit beta-B
</td>
</tr>
<tr>
<td style="text-align:left;">
HBAA_SERQU
</td>
<td style="text-align:left;">
Seriola
</td>
<td style="text-align:left;">
Hemoglobin subunit alpha-A
</td>
</tr>
</tbody>
</table>

The key step in this analysis is to obtain a good alignment with the
sequences. However, for simplicity, we will continue to use
ClustalWAlignment.

``` r
myClustalWAlignment <- msa::msaClustalW(fasta.files.filtered) %>%
  unmasked()
#> use default substitution matrix
myClustalWAlignment
#> AAStringSet object of length 194:
#>       width seq                                             names               
#>   [1]   315 ------------------MGLS...---------------------- MYG_ANAPO
#>   [2]   315 ------------------MGLS...---------------------- MYG_STRCA
#>   [3]   315 ------------------MGLS...---------------------- MYG_CARCR
#>   [4]   315 ------------------MGLS...---------------------- MYG_VARVA
#>   [5]   315 ------------------MVLS...---------------------- 4pqb_A
#>   ...   ... ...
#> [190]   315 ----------------------...---------------------- 5eys_A
#> [191]   315 ----------------------...---------------------- 5f0b_A
#> [192]   315 --------------------ME...---------------------- 4mpm_A
#> [193]   315 -----------------MEKLS...---------------------- NGB_DISMA
#> [194]   315 -----------------MEKLS...---------------------- NGB_DANRE
#We write the alignment in a file. 
```

At this point, we can annotate as we wish the sequence headers. This
point is critical because it is the information that pySCA will use
later to build the phylogenetic and functional dictionary. We are going
to construct a text string with the taxonomic information we want to use
and then write the file.

``` r
df.HBG2_HUMAN.ann <- df.HBG2_HUMAN.ann %>%
  distinct(alisqacc, .keep_all = TRUE)%>%
  unite(
    "unite_tax", c("superkingdom","kingdom","subphylum", "family", "genus"),
    sep = ",", na.rm = TRUE, remove = FALSE
    )
header <- myClustalWAlignment %>%
  names() %>%
  paste(df.HBG2_HUMAN.ann$unite_tax, sep = "|")
header[1:5]
#> [1] "MYG_ANAPO|Eukaryota,Metazoa,Craniata,Gadidae,Melanogrammus"
#> [2] "MYG_STRCA|Eukaryota,Metazoa,Craniata,Pipidae,Xenopus"      
#> [3] "MYG_CARCR|Eukaryota,Metazoa,Craniata,Cercopithecidae,Papio"
#> [4] "MYG_VARVA|Eukaryota,Metazoa,Craniata,Cercopithecidae,Papio"
#> [5] "4pqb_A|Eukaryota,Metazoa,Craniata,Carangidae,Seriola"

# myClustalWAlignment %>%
#   setNames(header) %>%
#   writeXStringSet("path_to_aln", format = "fasta")
```

### Running pySCA

Now, it’s time to use the pySCA scripts, `scaProcessMSA`, `scaCore`, and
`scaSectorID`.

``` bash
scaProcessMSA -a HBG2_HUMAN.ClustalW.aln
scaCore -i HBG2_HUMAN.ClustalW.db
scaSectorID -i HBG2_HUMAN.ClustalW.db
```

The resulting file is a .db file, and it is the pickle database with all
the results. We can now access them using Python and following the pySCA
example notebooks. However, we can access some of the information using
the following functions provided by the library. To use them we need to
have pySCA installed, which should not be a problem, since to read the
file we would have to generate it first. If you do not have it
installed, use the force = TRUE option. In fact, this command can be
used to create a virtual environment or a conda environment and
automatically install all the libraries.

``` r
pysca <- import_pySCA_module_using_reticulate(
  virtualenv = "r-pySCA", force_installing = FALSE)
db <- read_pySCA_pickle("inst/extdata/HBG2_HUMAN.ClustalW.db")
attributes(db)
```

### Interpretation of the results and sector definition

Now, we can analyze all the information calculated by pySCA using R, as
it is contained in the `pySCA_HBG2_HUMAN` file. To access it we use the
`$` operators.

However, there are a number of functions that facilitate the creation of
the graphs that appear in pySCA notebooks. These functions are grouped 2
by 2, one to gather the information into a data frame suitable for plot
and analysis and the other to make a default graph. Let’s look at some
examples.

#### Alignment

First, we print out a few statistics describing the alignment:

``` r
library(glue)
#> 
#> Attaching package: 'glue'
#> The following object is masked from 'package:IRanges':
#> 
#>     trim

glue("After processing, the alignment size is {Nseq} sequences and {Npos}",
     " positions. With sequence weights, there are {effseqs} effective sequences",
     Nseq = db$sequence$Nseq, Npos = db$sequence$Npos, effseqs = db$sequence$effseqs)
#> After processing, the alignment size is 175 sequences and 139 positions. With sequence weights, there are 54.4160788041247 effective sequences
```

To examine alignment composition, we plot a histogram of all pairwise
sequence identities.

``` r
#data <- pairwise_sequence_identities_data(db)
pairwise_sequence_identities_hist(db)
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />

And a global view of the sequence similarity matrix.

``` r
#data <- global_similarity_matrix_data(db)
global_similarity_matrix_heatmap(db)
```

<img src="man/figures/README-unnamed-chunk-11-1.png" width="100%" /> We
can observe the relationship between sequence similarity and phylogeny
by looking at the projection of the sequences onto the first 2 PCA and
IC, distinguishing which weights were included.

``` r
library(ggplot2)
db %>%
  sequence_correlation_matrix_projections_data() %>%
  left_join(df.HBG2_HUMAN.ann %>%
    mutate(hd = header), by = c("hd" = "hd"))%>%
  ggplot(aes(x=V1, y=V2)) +
    geom_point(aes(colour = .data$class)) +
    ggplot2::labs(x = "V1", y = "V2")+
    ggplot2::facet_grid(.data$type.projections ~ .data$mode, scales = "free")
```

<img src="man/figures/README-unnamed-chunk-12-1.png" width="100%" /> We
can also plot the position-specific conservation values or access the
SCA correlation matrix.

``` r
sca.matrix <- SCA_correlation_matrix_data(db)
position_specific_conservation_plot(db)
```

<img src="man/figures/README-unnamed-chunk-13-1.png" width="100%" />
Particularly useful is the function
`eigenspectrum_SCA_positional_coevolution_matrix_plot`, because it is
used to choose the number of significant eigenmodes. That function plots
the eigenspectrum histogram of the SCA positional coevolution matrix and
10 matrix randomization trials for comparison.

``` r
eigenspectrum_SCA_positional_coevolution_matrix_plot(db)
```

<img src="man/figures/README-unnamed-chunk-14-1.png" width="100%" /> To
access the sectors we can make use of the DataFrame that is created when
we read the pickle file. If we wanted to visualize the results in pyMol,
we could make use of the `write_sectors_for_pymol` function.

``` r
sectors <- db$sector$ics_tidy_df
sectors %>%
  group_by(ics) %>%
  summarise(positions = n())
#> # A tibble: 6 × 2
#>   ics   positions
#>   <chr>     <int>
#> 1 1            11
#> 2 2            17
#> 3 3            13
#> 4 4            17
#> 5 5            13
#> 6 6             8
write_sectors_for_pymol(db, fetch_pdb = "1FDH",output_file = "inst/extdata/1FDH_sectors.pml")
```
