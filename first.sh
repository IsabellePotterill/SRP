##PIPELINE for processing Raw RNA data as processed in paper

#prefix for the path of the Raw RNA Data dir (containing subdir, which contain 2 fastq.gz files
path="/home/graham/Downloads/trial/Data/"
#loop through files in Dir
for i in /home/graham/Downloads/trial/Data/*
do
	#suffixes for paired reads
	one="_1.fastq.gz"
	two="_2.fastq.gz"
	echo this $i
	#j becomes the current file path, minus the dir path - i.e. the name of the subdir
	j=${i#$path}
	#one and two are concatenated from previous parts to create the full path to the fastq files
	one=$i"/"$j$one
	two=$i"/"$j$two
	echo "file $one"
	echo "file $two"
	#runs prinseq++ as specficied in paper on the 2 fastq files
	#not sure about the setting on lc_entropy, but it seems to work
	prinseq++ -min_len 30 -trim_left 10 -trim_qual_right 25 -lc_entropy 0.65 -threads 3 -fastq $one -fastq2 $two -out_name $j -out_bad /dev/null/ -out_bad2 /dev/null/ -out_single /dev/null/ -out_single2 /dev/null/
	#the output from this doesn't work with '|' (pipe) yet, as it doesn't seem to appear in stdout
	#we can just keep outputting, using and deleting each file as we go (otherwise we'll run out of storage)
	#tar zcf $j.tar.gz 
done

