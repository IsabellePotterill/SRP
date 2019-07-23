## Generates a new matrix with appropiate sample names
import os

entries = os.listdir("Data/")

info = []
genes = []
with open('GSM1657871_1772078217.C03.csv') as tsvfile:
    reader = tsvfile.readlines()
    for row in reader:
        tri = row.rstrip('\n')
        th = tri.split('\t')
        genes.append(th[0])

for entry in entries:
    with open(entry) as en:
        tr = en.readlines()
        i=0
        for rt in tr:
            po = rt.rstrip('\n')
            ug = po.split('\t')
            genes[i] += '\t' + ug[1]
            i+=1

# Appends just the sample_name, without chip_info and suffix ".csv" file format 
for entry in entries:
	sample_name = entry.split('_')
	#print(lol)
	info.append(sample_name[0])        
	#print(ent)
	

ent = ['Gene_name'] + info

with open('output1.tsv', 'w') as ref:
    ref.write('\t'.join(ent)+ '\n')
    for name in genes:
        #print(thin)
        ref.writelines(name + '\n')


