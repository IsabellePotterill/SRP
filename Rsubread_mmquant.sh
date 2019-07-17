path="/home/graham/Downloads/our_pipeline/"
#loop through files in Dir
for i in $path"Raw_RNA_Data/"*
do
	#suffixes for paired reads in their gzip files
	fastq1="_1.fastq.gz"
	fastq2="_2.fastq.gz"
	#j becomes the current file path, minus the dir path - i.e. the name of the subdir
	j=${i#$path"Raw_RNA_Data/"}
	#one and two are concatenated from previous parts to create the full path to the fastq files
	one=$i"/"$j$fastq1
	two=$i"/"$j$fastq2
	Rscript Rsubread.R $one $two $path"38_index" $j".bam"
	mv $j".bam" "/media/graham/External2TB/Graham/"
	#concatenate 
	total=$total" ""/media/graham/External2TB/Graham/"$j".bam"
	#These can be merged with a python script later
done
#Parse later
mmquant -a $path"gencode.v31.annotation.gtf" -r $total -t 4 -g -o "All_Out_mmquant.csv" -O "Stats_report"
echo "Job done!"
