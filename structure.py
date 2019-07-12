import os

def geneList():
    genes = []
    with open('Data/GSM1657871_1772078217.C03.csv') as tsvfile:
        reader = tsvfile.readlines()
        for row in reader:
            tri = row.rstrip('\n')
            th = tri.split('\t')
            genes.append(th[0])
    return(genes)

def entryList(entries, genesf):
    for entry in entries:
        with open(entry) as en:
            tr = en.readlines()
            i=0
            for rt in tr:
                po = rt.rstrip('\n')
                ug = po.split('\t')
                genesf[i] += '\t' + ug[1]
                i+=1
    return(genesf)

def trim(fre):
    for i in range(3):
        fre.pop(-1)
    return fre

def runTable():
    thing = []
    with open('SraRunTable.tsv') as filed:
        readr = filed.readlines()
        for ro in readr:
            number = ro.split('\t')
            thing.append(number[9:13])
    return thing

def seParate(entries, thing):
    pre = 'prenatal'
    fe = []
    ne=[]
    no = 0
    names1=['']
    names2=['']
    neuro = 'neurons'

    for entry in entries:   
        no +=1
        for item in thing:
            if item[0] in entry:
                if pre in item[1]:
                    names1.append(entry)
                    fe.append(no)
                else:
                    if neuro in item[3]:
                        names2.append(entry)
                        ne.append(no)
    return names1,names2, fe, ne

def sortIng(listn, genesn, genesh):
    h=0
    for rhu in genesn:
        for i in listn:
            rew = rhu.split('\t')
            genesh[h] += '\t' + rew[i]   
        h+=1
    return genesh

def outPut(filename, genesk, names):
    with open(filename, 'w') as ref:
        ref.write('\t'.join(names)+ '\n')
        for thin in genesk:
            ref.writelines(thin + '\n')

entries = os.listdir("Data/")

names = [''] + entries

genes = geneList()
again = geneList()
againagain = geneList()

entry = entryList(entries, genes)

trug = trim(entry)
againtr = trim(again)
againagaintr = trim(againagain)

table = runTable()

n1, n2, fe, ne = seParate(entries, table)

genes1 = sortIng(fe, trug, againtr)
genes2 = sortIng(ne, trug, againagaintr)


outPut('fetest.tsv', genes1, n1)
outPut('netest.tsv', genes2, n2)
outPut('strtest.tsv', trug, names)

