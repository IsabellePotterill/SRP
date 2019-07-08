##SC3: for clustering (tutorial included)
# http://www.bioconductor.org/packages/release/bioc/vignettes/SC3/inst/doc/SC3.html#cluster-stability 

#if (!requireNamespace("BiocManager", quietly=TRUE))
#  install.packages("BiocManager")
#BiocManager::install("singleCellTK")
library(SingleCellExperiment)
library(SC3)
library(scater)
library(S4Vectors)
library(registry)
library(pkgmaker)
library(SCnorm)
library(scran)
library(scde)
library(RUVSeq)
library(simpleSingleCell)
library(SummarizedExperiment)

sce<- SingleCellExperiment(
  assays = list(
    counts = as.matrix(trial),
    logcounts = log2(as.matrix(trial) + 1)
  ), 
  colData = pipe
)

head(pipe)

rowData(sce)$feature_symbol <- rownames(sce)
sce <- sce[!duplicated(rowData(sce)$feature_symbol), ]
sce <- sc3_prepare(sce)
str(metadata(sce)$sc3)
sce <- sc3_estimate_k(sce)
str(metadata(sce)$sc3)
sce <- sc3_calc_dists(sce)
names(metadata(sce)$sc3$distances)
sce <- sc3_calc_transfs(sce)
names(metadata(sce)$sc3$transformations)
metadata(sce)$sc3$distances
#num_cells 2,000, k = 50
sce <- sc3_kmeans(sce, ks = 2:11)
names(metadata(sce)$sc3$kmeans)

#clustering solution
col_data <- colData(sce)
head(col_data[ , grep("sc3_", colnames(col_data))])
sce <- sc3_calc_consens(sce)
names(metadata(sce)$sc3$consensus)
names(metadata(sce)$sc3$consensus$`3`)
metadata(sce)$sc3$kmeans
col_data <- colData(sce)
head(col_data[ , grep("sc3_", colnames(col_data))])
plotPCA(sce, colour_by = "sc3_8_clusters")
