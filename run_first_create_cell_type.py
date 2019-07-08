##Run in the same direct as "chocolate.py" script
#generates a new output2.csv file, sample_names edited
import os

entries = os.listdir("Data/")


lista = []
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

##(new part): Appends just the sample_name
for entry in entries:
	lol = entry.split('_')
	#print(lol)
	lista.append(lol[0])        
	#print(ent)
	

ent = ['Gene_name'] + lista

with open('output1.tsv', 'w') as ref:
    ref.write('\t'.join(ent)+ '\n')
    for thin in genes:
        #print(thin)
        ref.writelines(thin + '\n')


