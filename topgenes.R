
cluster1 <-c()
cluster2 <-c()
cluster3 <-c()
cluster4 <-c()
cluster5 <-c()
cluster6 <-c()
cluster7 <-c()
cluster8 <-c()
cluster9 <-c()

count = 1
for(k in row.names(all)){
  meh <- yoghurt$classification[count]
  count <- count + 1
    if (meh %in% 1){cluster1<-append(cluster1,k)}
    else if (meh %in% 2){cluster2<-append(cluster2,k)}
    else if (meh %in% 3){cluster3<-append(cluster3,k)}
    else if (meh %in% 4){cluster4<-append(cluster4,k)}
    else if (meh %in% 5){cluster5<-append(cluster5,k)}
    else if (meh %in% 6){cluster6<-append(cluster6,k)}
    else if (meh %in% 7){cluster7<-append(cluster7,k)}
    else if (meh %in% 8){cluster8<-append(cluster8,k)}
    else if (meh %in% 9){cluster9<-append(cluster9,k)}
}

hopeful1<-test1[,cluster1]
hopeful2<-test1[,cluster2]
hopeful3<-test1[,cluster3]
hopeful4<-test1[,cluster4]
hopeful5<-test1[,cluster5]
hopeful6<-test1[,cluster6]
hopeful7<-test1[,cluster7]
hopeful8<-test1[,cluster8]
hopeful9<-test1[,cluster9]

topgene <- function(hopeful){
  total<- rowSums(hopeful);
  hopeful<-cbind(hopeful,total);
  ordered1 <- hopeful[order(-total),];
  #genes1 <-row.names(ordered1[1:20,]);
  return(ordered1)
}

genes1<-topgene(hopeful1)
genes2<-topgene(hopeful2)
genes3<-topgene(hopeful3)
genes4<-topgene(hopeful4)
genes5<-topgene(hopeful5)
genes6<-topgene(hopeful6)
genes7<-topgene(hopeful7)
genes8<-topgene(hopeful8)
genes9<-topgene(hopeful9)
out<-topgene(outputsm)
