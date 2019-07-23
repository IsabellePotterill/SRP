#pipe2.tsv is the file that we need to generate a "sce" object, which contains tow columns: sample_name and cell_type.

list =[]
with open("SraRunTable.txt") as file:
    lines = file.readlines()
    for row in lines:
        line = row.split('\t')
        list.append(lol)

        with open('pipeline_info.tsv', 'w') as ref:
       		info = [[aa[9],aa[12]] for aa in list]
       		#print(info)
       		for item in info:
       			feature = '\t'.join(item)
       			ref.writelines(feature+'\n')



