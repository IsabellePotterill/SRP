# import fadapa
from fadapa import Fadapa
import sys

#take arguement from bash script (which will be $j)
name = sys.argv[1]

#load file
f = Fadapa('/home/graham/Downloads/trial/'+name+'_fastqc/fastqc_data.txt')

#get raw data of any module
pass_seq = f.raw_data('Overrepresented sequences')[0]
list_of_seqs = []
if pass_seq != ">>Overrepresented sequences	pass":
	for data in f.clean_data('Overrepresented sequences'):
		list_of_seqs.append(data[0])
output = ""
for things in list_of_seqs[1:]:
	output = output + " -a " + things
print(output)
###stdout from this MUST fit into cutadpt -a AAA -a GGG etc...
