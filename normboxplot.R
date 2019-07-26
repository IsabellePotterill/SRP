
library(tibble)
library(ggplot2)

normwholematrix<-norm(wholematrix)

gennormendomat<-matrix(endothelial, normwholematrix)
gennormfequimat<-matrix(fetalqui, normwholematrix)
gennormferepmat<-matrix(fetalrep, normwholematrix)
gennormmicromat<-matrix(microglia, normwholematrix)
gennormneuromat<-matrix(neurons, normwholematrix)

name <- rownames(genenormneuromat)

data1 <- as.data.frame(t(genenormneuromat))
colnames(data1) <- name
data2 <- as.data.frame(t(gennormendomat))
colnames(data2) <- name
data3 <- as.data.frame(t(gennormmicromat))
colnames(data3) <- name
data4 <- as.data.frame(t(gennormfequimat))
colnames(data4) <- name
data5 <- as.data.frame(t(gennormferepmat))
colnames(data5) <- name

All <- rbind(data1, data2, data3, data4, data5)
Sample <- c(rep("Adult neurons", nrow(data1)),rep("Endothelial cells", nrow(data2)),rep("Microglia", nrow(data3)),
            rep("Fetal neurons (quiescent)", nrow(data4)),rep("Fetal neurons (replicating)", nrow(data5)))

All <- add_column(All, Sample, .before= All$`HLA-A `)
attach(All)

All$Sample<-factor(All$Sample, levels = c("Adult neurons","Endothelial cells","Microglia","Fetal neurons (quiescent)","Fetal neurons (replicating)"))
All$Sample <- as.factor(All$Sample)
All$SEC61<-rowMeans(All[,12:15])
HLA_Box <- ggplot(data=All, aes(x=Sample, y=`HLA-A `)) + geom_boxplot()
HLA_Box + geom_jitter(shape = 19, position = position_jitter(0.3))+ labs(title="HLA-A",x="Type of cell",y="LogCPM")

