import os,imp
from xlwt import Workbook
from mygrades.grades import grades2wb

import p1.grades.grades as p1
import p2.grades.grades as p2
import p3.grades.grades as p3
import p4.grades.grades as p4

grp='C3'
# labs
lablist = ['p1','p2','p3','p4']
#
wb = Workbook()
#
sh = wb.add_sheet('grades')


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
sh.write(row0+i,col0,grp)
   
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
   
   grd = 0.0
   for crt in valByCritByGroup[grp].keys():
      grd += wgtByCrit[crt]*valByCritByGroup[grp][crt]

   sh.write(row0,col0+i,grd)
   i+=1

# grades per lab
row0=0
col0=0
i=0
for lb in lablist:
   sh = wb.add_sheet(lb)
   mymod = __import__(lb+'.grades.grades')
   valByCritByGroup = mymod.grades.grades.valByCritByGroup
   commByCritByGroup = mymod.grades.grades.commByCritByGroup
   mymod = __import__(lb+'.grades.'+lb+'corrector')
   if lb=='p1':
      criterias = mymod.grades.p1corrector.criterialist
      wgtByCrit = mymod.grades.p1corrector.wgtByCrit
   if lb=='p2':
      criterias = mymod.grades.p2corrector.criterialist
      wgtByCrit = mymod.grades.p2corrector.wgtByCrit
   if lb=='p3':
      criterias = mymod.grades.p3corrector.criterialist
      wgtByCrit = mymod.grades.p3corrector.wgtByCrit
   if lb=='p4':
      criterias = mymod.grades.p4corrector.criterialist
      wgtByCrit = mymod.grades.p4corrector.wgtByCrit
   j=0 
   for crt in criterias:
      sh.write(row0+j,col0,crt)
      sh.write(row0+j,col0+1,wgtByCrit[crt])
      sh.write(row0+j,col0+2,valByCritByGroup[grp][crt])
      sh.write(row0+j,col0+3,commByCritByGroup[grp][crt])
      j+=1
wb.save('grades'+grp+'.xls')
