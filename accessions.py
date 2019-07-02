
liston =[]
with open("filelist.txt") as lines1:
	lines = lines1.readlines()
	for row in lines:
        #print(row)
		lol = row.split('\t')
		print(lol)
		liston.append(lol)
		with open('SraInfo.tsv', 'w') as ref:
			#ent = ['Cell_no'] 
			#ref.write('\t'.join(ent)+ '\t')
			#dat = ['Data'] 
			#ref.write('\t'.join(dat)+ '\t')
			#lel = ['ID'] 
			#ref.write('\t'.join(lel)+ '\n')
			#print(lol)
			
			#print(liston)
			info = [aa[3] for aa in liston]
			#print(info)
			for wow in info:
				uff = '\t'.join(wow)
				#print(uff)
				ref.writelines(uff + '\n')
        		

	




