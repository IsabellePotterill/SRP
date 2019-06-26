library(scde)
library(mclust)
library(tsne)

output1 <- read.delim("~/SteeredRP/output1.tsv", header=TRUE)
list_genes<-outputsm$Gene_name
rownames(outputsm)<-list_genes
outputsm<-subset(outputsm, select=-Gene_name)
cd<-clean.counts(outputsm,min.lib.size=1000,min.reads=1,min.detected=1)
o.ifm <- scde.error.models(counts = cd, n.cores = 2, threshold.segmentation = TRUE, save.crossfit.plots = FALSE, save.model.plots = FALSE, verbose = 1)
valid.cells <- o.ifm$corr.a > 0
o.prior <- scde.expression.prior(models = o.ifm, counts = cd, length.out = 400, show.plot = FALSE)

p.self.fail <- scde.failure.probability(models = o.ifm, counts = cd)
n.simulations <- 10; k <- 0.9
cell.names<-colnames(cd)
names(cell.names) <- cell.names
dl <- mclapply(1:n.simulations,function(i) {
  scd1 <- do.call(cbind,lapply(cell.names,function(nam) {
    x <- cd[,nam];
    x[!as.logical(rbinom(length(x),1,1-p.self.fail[,nam]*k))] <- NA;
    x;
  }))
  rownames(scd1) <- rownames(cd); 
  cor(log10(scd1+1),use="pairwise.complete.obs");
}, mc.cores = 1)
direct.dist<- as.dist(1-Reduce("+",dl)/length(dl))


sne <-tsne(direct.dist)
izz <-Mclust(sne)
plot(izz)
