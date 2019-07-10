#pipe2.tsv is the file that we need to generate a "sce" object, which contains tow columns: sample_name and cell_type.

liston =[]
with open("SraRunTable.txt") as file:
    lines = file.readlines()
    for row in lines:
        lol = row.split('\t')
        liston.append(lol)
        #print(liston)
        with open('furtherInfoPipe.tsv', 'w') as ref:
       		info = [[aa[9],aa[11],aa[10],aa[12]] for aa in liston]
       		#print(info)
       		for item in info:
       			wow = '\t'.join(item)
       			ref.writelines(wow+'\n')

        with open('pipe2.tsv', 'w') as ref:
       		info = [[aa[9],aa[12]] for aa in liston]
       		#print(info)
       		for item in info:
       			wow = '\t'.join(item)
       			ref.writelines(wow+'\n')



