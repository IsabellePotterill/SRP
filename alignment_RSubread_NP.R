library(scPipe)
library(SingleCellExperiment)
library(SummarizedExperiment)
library(Rsubread)

#BiocManager::install("SC3")
#BiocManager::install("SingleCellExperiment")
#BiocManager::install("SummarizedExperiment")
#BiocManager::install("RUVSeq")
#BiocManager::install("Rsubread")
#BiocManager::install("scPipe")

#we need alignment file: human-genome-reference
#ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_28/GRCh38.primary_assembly.genome.fa.gz
ERCCfa_fn = file.path("/home/rpg18/Downloads/GRCh38.primary_assembly.genome.fa.gz")

#Builds the index of human-genome-reference
Rsubread::buildindex(basename=file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/Index38_GENCODE/", "ERCC_index"), 
                     reference=ERCCfa_fn, gappedIndex = TRUE)

#Read1 for cell1
fq_R1 = file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/reads/SRR1974543_1.fastq.gz")
#Read2 for cell2
fq_R2 = file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/reads/SRR1974543_2.fastq.gz")


#This step is just needed to create a combined.fastq file.(Both reads in same .bam file after alignment)
#we could do this in another way, maybe with fastp
#sc_trim_barcode(file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/", "combined.fastq.gz"),
#                fq_R1,
#                fq_R2,
#                read_structure = list(bs1=0, bl1=0, bs2=0, bl2=0, us=0, ul=0)) #we do not have barcodes, we do not need them


#Now we can proceed with the alignment. In this step we could use just one readfile (both reads together-combined.fastq file\\ 
#or we could have used readfile1 for the first read, and readfile2 for the second read [not sure if this is possible with both\\
#at the same time or individually])
Rsubread::align(index=file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/Index38_GENCODE/", "ERCC_index"),
                #readfile1=file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/", "combined.fastq.gz"),
                readfile1=file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/reads/", "SRR1974543_1.fastq.gz"),
                readfile2=file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/reads/", "SRR1974543_2.fastq.gz"),
                output_file=file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/", "out_final.aln.bam"), type=0) #type=0 for RNA-seq

#With this output: out_final.aln.bam, we are ready for the counting

#The BAM file is already sorted. But we could have sorted the BAM file by names (for example) using SAMTOOLS (command-line): 
#samtools sort -n out.aln.bam -o out_sort.bammtools sort -n 

#We now run HTSeq (htseq-count) to generate the counting matrix:
#Quick installation of HTSeq:
#pip install HTSeq
##HTSeq:
#ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_28/gencode.v28.annotation.gff3.gz
#htseq-count -r name -f bam -s no --additional gene_name out_final.aln.bam /home/rpg18/Downloads/gencode.v28.annotation.gff3.gz > output_CountsMatrix.csv
