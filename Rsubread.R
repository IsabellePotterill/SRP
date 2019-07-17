#R commands to be called from bash script using Rscript command

args = commandArgs(trailingOnly=TRUE)
# test if arguments are OK
if (length(args)!=4) {
  stop("Eejit. Needs read1, read2, gtf and output paths.n", call.=FALSE)
}

fq_R1 = file.path(args[1])
fq_R2 = file.path(args[2])
IndexPath = file.path(args[3])
Outpath = file.path(args[4])

Rsubread::align(index=IndexPath,
                readfile1=fq_R1,
                readfile2=fq_R2,
                type=0, #0 for rna
                output_file=Outpath,
                nthreads = 4 #Number of cores to use...
)
##Wobsite

gre<-PCA(mergesort, graph=FALSE)
collist = c()
for(k in row.names(mergesort)){
  if (k %in% quiefe[,1]){
    print(k)
    collist<-append(collist, 'green')
  }
  else if (k %in% replfe[,1]){
    collist <- append(collist, 'purple')
  }
  else if (k %in% neuls[,1]){
    collist <- append(collist, 'red')
  }
}

pca<-function(distmat, file1, file2, file3){
  #output this
  gre<-PCA(distmat, graph=FALSE) # make pca not plot random plots
  #and this for to upload for website
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
  plot3d(gre$ind$coord[,1:3], col = collist)
}
#Hook up the input link to the colour of the groups.

#Make the input go into Rshiny
fenepca<-pca(mergesort, quiefe, replfe, neuls)

library(shiny)

devtools::install_github("BaderLab/scClustViz")
runApp("App-1")




###feature COunts
annot = file.path("/home/graham/Downloads/our_pipeline", "gencode.v31.annotation.gtf")
index = file.path("/home/graham/Downloads/our_pipeline/GRCh38.primary_assembly.genome.fa")
files = list.files("/media/graham/External2TB/Graham")
setwd("/media/graham/External2TB/Graham")
output <- featureCounts(files,
                         
                         # annotation
                         annot.inbuilt = index,
                         annot.ext= annot,
                         isGTFAnnotationFile=TRUE,
                         GTF.featureType="gene",
                         GTF.attrType="gene_name",
                         chrAliases=NULL,
                         
                         # level of summarization
                         useMetaFeatures=TRUE,
                         
                         # overlap between reads and features
                         allowMultiOverlap=FALSE,
                         minOverlap=1,
                         largestOverlap=FALSE,
                         readExtension5=0,
                         readExtension3=0,
                         read2pos=NULL,
                         
                         # multi-mapping reads
                         countMultiMappingReads=FALSE,
                         fraction=FALSE,
                         
                         # read filtering
                         minMQS=0,
                         splitOnly=FALSE,
                         nonSplitOnly=FALSE,
                         primaryOnly=FALSE,
                         ignoreDup=FALSE,
                         
                         # strandness
                         strandSpecific=0,
                         
                         # exon-exon junctions
                         juncCounts=FALSE,
                         genome=NULL,
                         
                         # parameters specific to paired end reads
                         isPairedEnd=TRUE,
                         requireBothEndsMapped=TRUE,
                         checkFragLength=TRUE,
                         #minFragLength=50,
                         #maxFragLength=600,
                         countChimericFragments=TRUE,    
                         autosort=FALSE,
                         
                         # miscellaneous
                         nthreads=4,
                         maxMOp=10 )
