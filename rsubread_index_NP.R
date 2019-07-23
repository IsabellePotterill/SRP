library(SingleCellExperiment)
library(Rsubread)

#BiocManager::install("SingleCellExperiment")
#BiocManager::install("RUVSeq")
#BiocManager::install("Rsubread")

## Inputs ----
# alignment file: human-genome-reference
#ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_28/GRCh38.primary_assembly.genome.fa.gz
ERCCfa_fn = file.path("/home/rpg18/Downloads/GRCh38.primary_assembly.genome.fa.gz")

#Builds the index of human-genome-reference
Rsubread::buildindex(basename=file.path("/path/Index38_GENCODE/", "ERCC_index"), 
                     reference=ERCCfa_fn, gappedIndex = TRUE)
