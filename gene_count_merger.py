import os

entries = os.listdir("Data/")

genes = []
with open('Data/GSM1657871_1772078217.C03.csv') as tsvfile:
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

ent = ['Gene_name'] + entries

with open('outputsm.tsv', 'w') as ref:
    ref.write('\t'.join(ent)+ '\n')
    for thin in genes:
        print(thin)
        ref.writelines(thin + '\n')
