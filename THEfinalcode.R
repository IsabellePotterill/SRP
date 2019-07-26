library(scde)
library(mclust)
library(tsne)
library(parallel)
library(igraph)
library(FactoMineR)


wholematrix <- read.delim('~/SteeredRP/wholematrix.tsv', header=TRUE, row.names = 1)
neurons <- read.delim("~/SteeredRP/neurons.tsv")
foetal <- read.delim("~/SteeredRP/prenatal.tsv")
endothelial<-read.delim("~/SteeredRP/endothelial.tsv")
microglia<-read.delim("~/SteeredRP/microglia.tsv")
fetalqui<- read.delim("~/SteeredRP/fetalqui.tsv")
fetalrep<-read.delim("~/SteeredRP/fetalrep.tsv")

neuronmat<-wholematrix[,neurons$V1]
foetalmat<-wholematrix[,foetal$V1]

fenemerge <- merge(foetalmat, neuromat, by=0, all = TRUE)
row.names(fenemerge)<-fenemerge$Row.names
fenemerge$Row.names<-NULL

sorting<-function(fileread){
  cd<-clean.counts(fileread,min.lib.size=1800,min.reads=1,min.detected=1)
  o.ifm <- scde.error.models(counts = cd, n.cores = 2, threshold.segmentation = TRUE, save.crossfit.plots = FALSE, save.model.plots = FALSE, verbose = 1)
  valid.cells <- o.ifm$corr.a > 0
  o.ifm <- o.ifm[valid.cells, ]
  o.prior <- scde.expression.prior(models = o.ifm, counts = cd, length.out = 400, show.plot = FALSE)
  
  p.self.fail <- scde.failure.probability(models = o.ifm, counts = cd)
  n.simulations <- 1000; k <- 0.9
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
  }, mc.cores = 3)
  there<-1-Reduce("+",dl)/length(dl)
  return(there)}

tsned<-function(distmat){
  direct.dist<- as.dist(distmat)
  sne <-tsne(direct.dist, k=3)
  yoghurt<-Mclust(sne, G=1:40, modelNames = c("EII","VII", "EEI", "VEI", "EVI", "VVI", "EEE", "EEV", "VEV", "VVV"),prior=priorControl())
  plot(yoghurt$BIC, colors = c("gray", "black", "orange", "darkred", "red", "magenta", "darkgreen", "green","lightblue","darkblue"))
  boxplot(yoghurt$z)
  cluslist<- c()
  for (num in yoghurt[["classification"]]){
    if (num %in% 1){cluslist<-append(cluslist,'black')}
    else if (num %in% 2){cluslist<-append(cluslist,'orange')}
    else if (num %in% 3){cluslist<-append(cluslist,'purple')}
    else if (num %in% 4){cluslist<-append(cluslist,'green')}
    else if (num %in% 5){cluslist<-append(cluslist,'red')}
    else if (num %in% 6){cluslist<-append(cluslist,'blue')}
    else if (num %in% 7){cluslist<-append(cluslist,'yellow')}
    else if (num %in% 8){cluslist<-append(cluslist,'cyan')}
    else if (num %in% 9){cluslist<-append(cluslist,'pink')}
  }
  grahamlist<-c()
  for(k in row.names(all)){
    if (k %in% opc$V1){grahamlist<-append(grahamlist, 'green')}
    else if(k %in% astrocyte$V1){grahamlist<-append(grahamlist, 'purple')}
    else if(k %in% micro$V1){grahamlist<-append(grahamlist, 'blue')}
    else if(k %in% endo$V1){grahamlist<-append(grahamlist, 'black')}
    else if(k %in% neuls$V1){grahamlist<-append(grahamlist, 'orange')}
    else if(k %in% fetalqui$V1){grahamlist<-append(grahamlist, 'red')}
    else if(k %in% replfe$V1){grahamlist<-append(grahamlist, 'magenta')}
    else if(k %in% hybrid$V1){grahamlist<-append(grahamlist, 'cyan')}
    else if(k %in% oligo$V1){grahamlist<-append(grahamlist, 'grey')}
    else{grahamlist<-append(grahamlist, k)}
  }  
  
  plot_ly(as.data.frame(sne), x = sne[,1], y= sne[,2], z= sne[,3], type = 'scatter3d', marker= list(color = cluslist, size=1))
  plot_ly(as.data.frame(sne), x = sne[,1], y= sne[,2], z= sne[,3], type = 'scatter3d', marker= list(color = grahamlist, size=1))
}

tree<-function(distmat){
  grapho<-graph.adjacency(as.matrix(distmat), weighted=TRUE, mode = "lower")
  minm<-mst(grapho)
  com<-cluster_walktrap(minm)
  V(minm)$color<-c("blue", "green", "magenta", "red", "gray", "black", "orange", "darkred", "magenta", "darkgreen","lightblue","darkblue", "purple")[membership(com)] #add 13 cols to list
  return(minm)
}

pca<-function(distmat, file1, file2, file3){
  gre<-PCA(distmat, graph = FALSE) # make pca not plot random plots
  collist = c()
  for(k in row.names(distmat)){
    if (k %in% file1[,1]){
      print(k)
      collist<-append(collist, 'green')
    }
    else if (k %in% file2[,1]){
      collist <- append(collist, 'purple')
    }
    else if (k %in% file3[,1]){
      collist <- append(collist, 'red')
    }
  }
  plot_ly(as.data.frame(gre$ind$coord), x = ~Dim.1, y= ~Dim.2, z= ~Dim.3,type = 'scatter3d', marker= list(color = collist, size=1))
  fren<-dimdesc(gre)
  return(gre)
}

norm <-function(data){
  for (i in 1:length(names(data))){
    sumf<-sum(data[,i])
    for (cell in 1:length(data[,i])){
      cell1 = (data[cell,i]/sumf)*10^6
      if (cell1 > 1) {
        cell2 = log10(cell1)
      }
      else{
        cell2 = log10(1)
      }
      data[cell,i] <- cell2
    }}
  return(data)}

matrix<-function(input, matrix){
  genesss <- c("HLA-A", "HLA-B", "HLA-C", "B2M", "TAPBP", "CALR", "ERAP1", "HSPA5", "PDIA3", "TAP2", "SEC61A1", "SEC61A2", "SEC61B", "SEC61G")
  cols<-as.vector(input$V1)
  matrix1<-matrix[genesss,input]
  return(matrix1)
}

allsort<-sorting(normwholematrix)
neuronsort<-sorting(neuronmat)
foetalsort<-sorting(foetalmat)
mergesort<-sorting(fenemerge)

altsne<-tsned(allsort)

fetreegra<-tree(foetalsort)
nertreegra<-tree(neuronsort)

plot(fetreegra, layout=layout.fruchterman.reingold, vertex.size=4, vertex.label=NA, asp=FALSE, edge.arrow.mode=0)
plot(nertreegra, layout=layout.fruchterman.reingold, vertex.size=4, vertex.label=NA, asp=FALSE, edge.arrow.mode=0)

fenepca<-pca(mergesort, quiefe, replfe, neuls)


