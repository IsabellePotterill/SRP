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
