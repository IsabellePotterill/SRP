import os

entries = os.listdir("Data/")


genes = []
genes2 = []
genes3 = []
with open('GSM1657871_1772078217.C03.csv') as tsvfile:
    reader = tsvfile.readlines()
    for row in reader:
        tri = row.rstrip('\n')
        th = tri.split('\t')
        genes.append(th[0])
        genes2.append(th[0])
        genes3.append(th[0])

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
        ref.writelines(thin + '\n')
#print(genes)


thing = []
with open('SraRunTable.tsv') as filed:
    readr = filed.readlines()
    for ro in readr:
        number = ro.split('\t')
        thing.append(number[9:11])

pre = 'prenatal'
fe = []
ad=[]
no = 0
names1=['Gene_name\t']
names2=['Gene_name\t']

for entry in entries:   
    no +=1
    for item in thing:
        if item[0] in entry:
            if pre in item[1]:
                names1.append(entry + '\t')
                fe.append(no)
            else:
                names2.append(entry + '\t')
                ad.append(no)

fre = []
gfd = []
h=0
l=0

for rhu in genes:

    for i in ad:    
        rew = rhu.split('\t')
        genes2[h] += '\t' + rew[i]   
    h+=1
    for j in fe:
        genes3[l] += '\t' + rew[j]
    l += 1

with open('ad.tsv', 'w') as adult:
    num = 0
    adult.writelines(','.join(names2) + '\n')
    for thingre in genes2:
        adult.writelines(thingre +'\n')

with open('fe.tsv', 'w') as foetal:
    foetal.writelines(','.join(names1) + '\n')
    for thrh in genes3:
        foetal.writelines(thrh + '\n')


