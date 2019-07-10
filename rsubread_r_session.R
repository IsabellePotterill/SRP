library(scPipe)
library(SingleCellExperiment)
library(SummarizedExperiment)
library(Rsubread)


#buildindex(basename, reference, gappedIndex = FALSE, 
#           indexSplit = FALSE,memory = 8000, TH_subread = 100, colorspace = FALSE)

#we need alignment file: human-genome-reference
ERCCfa_fn = file.path("/home/rpg18/Downloads/Homo_sapiens.GRCh38.cdna.all.fa.gz") #I have tried with cDNA
#we need annotation file: human-annotation-reference
ERCCanno_fn = file.path("/home/rpg18/Downloads/gencode.v28.annotation.gff3.gz")

#Read1 for cell1
fq_R1 = file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/reads/SRR1974543_1.fastq.gz")
#Read2 for cell2
fq_R2 = file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/reads/SRR1974543_2.fastq.gz")


#This step is just needed to create a combined.fastq file.(Both reads in same .bam file after alignment)
#we could do this in another way, maybe with fastp
sc_trim_barcode(file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/", "combined.fastq.gz"),
                fq_R1,
                fq_R2,
                read_structure = list(bs1=0, bl1=0, bs2=0, bl2=0, us=0, ul=0)) #we do not have barcodes, we do not need them

#Builds the index of human-genome-reference
Rsubread::buildindex(basename=file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/Index_ensembl_cdna38/", "ERCC_index"), 
                     reference=ERCCfa_fn, gappedIndex = TRUE)

#Now we can proceed with the alignment. In this step we could use just one readfile (both reads together-combined.fastq file\\ 
#or we could have used readfile1 for the first read, and readfile2 for the second read [not sure if this is possible with both\\
#at the same time or individually])
Rsubread::align(index=file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/Index_ensembl_cdna38/", "ERCC_index"),
                readfile1=file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/", "combined.fastq.gz"),
                #readfile1=file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/reads/", "SRR1974543_1.fastq.gz"),
                #readfile2=file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/reads/", "SRR1974543_2.fastq.gz"),
                output_file=file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/", "out2.aln.bam"), type=0) #type=0 for RNA-seq

#With this output: out2.aln.bam, we are ready for the counting

#We try now to run HTSeq (htseq-count) to generate the counting matrix:

#Quick installation of HTSeq:
#pip install HTSeq
#htseq-count 
####################################

#Example of annotation following scPipe tutorial, this is optional. We actually are not trying this, but we could
sc_exon_mapping(file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/", "out.aln.bam"),
                 file.path("/home/rpg18/Desktop/SRP_article/ALL_DATA/Fastq_files/", "out.map.bam"),
                 ERCCanno_fn)
