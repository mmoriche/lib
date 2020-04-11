import os,imp
from xlwt import Workbook
from mygrades.grades import grades2wb

import p1.grades.grades as p1
import p2.grades.grades as p2
import p3.grades.grades as p3
import p4.grades.grades as p4

# labs
lablist = ['p1','p2','p3','p4']
# groups
nByGroup = {'A':12,'B':8,'C':8,'D':5}
groups = []
for l in ['A','B','C','D']:
   for n in range(1,nByGroup[l]+1):
      groups.append('%s%d'%(l,n))
#
wb = Workbook()
#
sh = wb.add_sheet('grades')
# header
row0=1
col0=1
sh.write(row0,col0,'GROUP')
i=1
for lb in lablist:
   sh.write(row0,col0+i,lb)
   i+=1
sh.write(row0,col0+i,'TOTAL')
# groups rower
row0=2
col0=1
i=0
for grp in groups:
   sh.write(row0+i,col0,grp)
   i+=1
   
# grades per lab
row0=2
col0=2
i=0
for lb in lablist:
   mymod = __import__(lb+'.grades.grades')
   valByCritByGroup = mymod.grades.grades.valByCritByGroup
   mymod = __import__(lb+'.grades.'+lb+'corrector')
   if lb=='p1':
      wgtByCrit = mymod.grades.p1corrector.wgtByCrit
   if lb=='p2':
      wgtByCrit = mymod.grades.p2corrector.wgtByCrit
   if lb=='p3':
      wgtByCrit = mymod.grades.p3corrector.wgtByCrit
   if lb=='p4':
      wgtByCrit = mymod.grades.p4corrector.wgtByCrit
   
   j=0
   for grp in groups:
      grd = 0.0
      if grp in valByCritByGroup.keys():
         for crt in valByCritByGroup[grp].keys():
            grd += wgtByCrit[crt]*valByCritByGroup[grp][crt]

      sh.write(row0+j,col0+i,grd)
      j+=1
   i+=1
wb.save('2012_2013_grades.xls')
