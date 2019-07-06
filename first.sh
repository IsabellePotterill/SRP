##PIPELINE for processing Raw RNA data as processed in paper

#prefix for the path of the Raw RNA Data dir (containing subdir, which contain 2 fastq.gz files
path="/home/graham/Downloads/trial/Data/"
#loop through files in Dir
for i in /home/graham/Downloads/trial/Data/*
do
	mkdir Junk
	cd Junk
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
	#set the suffixes to the new output pair
	one="_good_out_R1.fastq"
	two="_good_out_R2.fastq"
	fastqc $j$one $j$two --extract -t 3
	parse_fastqc1=$(python3 fafapa_call.py $j"_good_out_R1")
	parse_fastqc2=$(python3 fafapa_call.py $j"_good_out_R2")
	echo "output of python "$parse_fastqc1
	echo "output of python "$parse_fastqc2
	cutadapt $parse_fastqc1 -e 0.15 -m 30 -o cutadR1$j.fastq -j 3 $j$one
	cutadapt $parse_fastqc2 -e 0.15 -m 30 -o cutadR2$j.fastq -j 3 $j$one
	prinseq++ -min_len 30 -fastq cutadR1$j.fastq -fastq2 cutadR2$j.fastq -out_name trimmed$j -out_bad /dev/null/ -out_bad2 /dev/null/ -out_single /dev/null/ -out_single2 /dev/null/
	#CAN TRIM_GALORE TAKE PAIRED FILES??? YES! How does this work?
	trim_galore trimmed$j$one trimmed$j$two --stringency 1 --nextera --paired
	mv "trimmed"$j"_good_out_R1_trimmed.fq" "/home/graham/Downloads/trial/Data/Results"
	mv "trimmed"$j"_good_out_R1_trimmed.fq" "/home/graham/Downloads/trial/Data/Results"
	cd ..
	#IS THIS SAFE?!
	rm -rf Junk

	#STAR $whatever -outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverLmax 0.04 --alignIntronMin 20 --alignIntronMax 1000000 --alignMatesGapMax 1000000 --outSAMstrandField intronMotif
	#HTSeq -m intersection-nonempty -s no
done
