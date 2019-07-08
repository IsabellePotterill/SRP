##How to create a SingleCellExperiment object:

library(SingleCellExperiment)
library(SC3)
library(SummarizedExperiment)

#pipe2 with sample_name and cell_type info
pipe <- read.csv(("~/Desktop/SRP_article/ALL_DATA/pipe2.tsv"), sep='\t') 
pipe <- DataFrame(pipe)
pipe

library(scater)
library(Matrix)
#one way:
trial <- readSparseCounts(("~/Desktop/SRP_article/ALL_DATA/output1.tsv"), sep='\t') 
nrow(trial)
trial
trial<- trial[1:22085,]
nrow(trial)
trial

#another way:
#trial <- read.csv(("~/Desktop/SRP_article/ALL_DATA/output1.tsv"), sep='\t')
#trial<- trial[1:22085,]
#trial_genes <- trial$Gene_name
#rownames(trial) <- trial_genes
#trial <- subset(trial, select = -Gene_name)
#trial

#SC3 TUTORIAL:

sce<- SingleCellExperiment(
  assays = list(
    counts = as.matrix(trial),
    logcounts = log2(as.matrix(trial) + 1)
  ), 
  colData = pipe
)
#sce = single-cell-experiment object
sce


