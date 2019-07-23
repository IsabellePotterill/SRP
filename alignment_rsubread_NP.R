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
# Read1
fq_R1 = file.path("/path/_1.fastq.gz")
# Read2
fq_R2 = file.path("/path/_2.fastq.gz")

## Alignment ----
# Align each read with the human genome reference:
Rsubread::align(index=file.path("/path/Index38_GENCODE/", "ERCC_index"),
                readfile1=fq_R1,
                readfile2=ffq_R2,
                output_file=file.path("/path/", "out_final.aln.bam"), type=0) #type=0 for RNA-seq

#With this output: out_final.aln.bam, we are ready for the counting matrix creation

## Not_included: ----
#The BAM file is already sorted. But we could have sorted the BAM file by names (for example) using SAMTOOLS (command-line): 
#samtools sort -n out.aln.bam -o out_sort.bammtools sort -n 

#We now run HTSeq (htseq-count) to generate the counting matrix:
#Quick installation of HTSeq:
#pip install HTSeq
##HTSeq:
#ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_28/gencode.v28.annotation.gff3.gz
#htseq-count -r name -f bam -s no --additional gene_name out_final.aln.bam /home/rpg18/Downloads/gencode.v28.annotation.gff3.gz > output_CountsMatrix.csv
