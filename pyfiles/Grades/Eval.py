from Grades.Student import TeamGroup, findstudentinlist, findstudent
import os
import pickle
import shutil
from mytext import updatecompleter
import readline
import xlwt
import xlrd
from mygrades.xls import header1,rower1arr
from Excel.Excel import data2sh, data2shpretty
import re
import math


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

    def disable(self):
        self.HEADER = ''
        self.OKBLUE = ''
        self.OKGREEN = ''
        self.WARNING = ''
        self.FAIL = ''
        self.ENDC = ''

def getfinalgrade(originalvalue, frmtindx):

   #if frmtindx==1:
   #   return math.ceil(originalvalue*10.)/10.
   #   #return originalvalue
   tol = 1e-5
   #print originalvalue, 'hola'
   #rint math.ceil(originalvalue*10.**frmtindx-tol)/10.**frmtindx, 'jeje'
   #rint originalvalue*10.**frmtindx, 'jaja'
   #rint math.ceil(originalvalue*10.**frmtindx), 'jaja'
   #rint 
   aa = math.ceil(originalvalue*10.**frmtindx-tol)/10.**frmtindx
   return aa 

class Evaluation:
   """
   Class to carry out the evaluation of one work

   - Initialized by name

   example:
   eval = Evaluation(name)
   """
   def __init__(self, name, parts={}, members=[], responsibles=[], order=[],path='.'):
      # mandatory
      self.name = name

      # optional
      self.parts = parts.copy()
      self.members = members[:]
      self.responsibles = responsibles[:]
      self.order = order[:]
      self.path = path

      self.critByME= {}
      self.versionByM= {}
      self.done = []

   def addfromother(self, other):
      """
       Copy all the information except the name from other instance
      """
      # lists
      self.members += other.members 
      for ordi in other.order:
         if not ordi in self.order:
            self.order.append(ordi)

      for part in other.parts.values():
         if not part in self.parts.values():
            self.parts[part.label] = part
         else:
            self.part[part.label].addfromother(part)

      self.path = other.path    
      self.critByME = dict(self.critByME.items()+other.critByME.items())
      self.done     += other.done    
      if not 'responsibles' in dir(other):
         pass
      else:
         self.responsibles += other.responsibles

   def migratefromother_ALL_to_EvalPart(self, other):
      """
       Copy all the information except the name from other instance
      """
      # lists
      self.members = other.members 
      self.members = other.members 
      self.order   = other.order   
      self.path    = other.path    

      #self.done    = other.done    
      #self.parts   = other.parts   
      #self.critByME= other.critByME

      for part in other.parts.values():
         if not part in self.parts.values():
            if part.__class__.__name__ == 'EvalPart':
               self.parts[part.label] = part
            elif part.__class__.__name__ == 'TestVPart':
               commentlist = ['test_ok', 'test_wrong', 'test_empty']
               valuelist   = [1.0, part.wrong,0.0]
               part2 = EvalPart(part.label, part.desc, part.gid)
               for i5 in range(len(commentlist)):
                  comm = commentlist[i5]
                  val  = valuelist[i5]
                  crit = Criterion(comm, val)
                  part2.valueByComment[comm] = val
                  part2.criterions.append(crit)
               self.parts[part.label] = part2
            else:
               print 'ERRROR, PART TYPE NOT HANDLED YET'

      # update evaluations
      #k = (member, self.parts[label])
      for (member,part) in other.critByME.keys():
         if part.__class__.__name__ == 'EvalPart':
            self.critByME[ (member,part) ] = other.critByME[(member,part)]
         elif part.__class__.__name__ == 'TestVPart':
            commentlist = ['test_ok', 'test_wrong', 'test_empty']
            valuelist   = [1.0, part.wrong,0.0]
            self.critByME[ (member,part) ] = []
            for crit in other.critByME[(member,part)]:
               #crit = other.critByME[(member,part)]
               ii = valuelist.index(crit.value) 
               crit2 = Criterion(commentlist[ii], valuelist[ii])
               self.critByME[ (member,part) ].append(crit2)
 
      return

   def copyfromother(self, other):
      """
       Copy all the information except the name from other instance
      """
      self.parts   = other.parts   
      self.members = other.members 
      self.order   = other.order   
      self.path    = other.path    
      self.critByME= other.critByME
      self.done    = other.done    

   def addpart(self, evalpart):
      """
      Adds an EvalPart to the member parts of the Evaluation instance

      Each EvalPart is associated with a label and saved in the 
       dictionary parts

      eval.addpart( EvalPart, label)
      """
      self.parts[evalpart.label] = evalpart

   def setorder(self, labellistoflist):
      """
      Sets the order of evaluation by a list of list of the labels

      eval.setorder( (('intro',), ('method1','method2'), ('conclusions',)))

      """
      self.order = labellistoflist[:]

   def setmembers(self, members):
      self.members = members[:]
   def addmembers(self, members):
      self.members += members[:]

   def setresponsibles(self, members):
      self.responsibles = members[:]
   def addresponsibles(self, members):
      if not member in self.responsibles:
         self.responsibles += members[:]
      else:
         pass
   def addresponsible(self, member):
      self.responsibles.append(member)
   def removeresponsible(self, member):
      newlist = []
      for st in self.responsibles:
         if not st == member:
            print st.name, member.name
            newlist.append(st)
      self.responsibles = newlist[:]

   def load(self,path=None, suffix=''):
      if not path: path = self.path

      fnm = os.path.join(path, 'evaluation_%s%s.pkl' % (self.name.replace(' ','_'), suffix))

      if os.path.isfile(fnm):
         f = open(fnm,'rb')
         other = pickle.load(f)
         f.close()
       
      else:
         other = Evaluation(self.name)

      self.addfromother(other)

   def save(self,path=None):
      if not path: path = self.path

      fnm = os.path.join(path, 'evaluation_%s.pkl' % self.name.replace(' ','_'))

      if os.path.isfile(fnm):shutil.copy(fnm, fnm.replace('.pkl','.pkl.bak'))

      f = open(fnm,'wb')
      pickle.dump(self,f)
      f.close()

   def updatecompleter(self):
     mylist = []
     for evalpart in self.parts.values():
        if evalpart.__class__.__name__ == 'EvalPart':
           for crit in evalpart.criterions:
              mylist.append(crit.comment)
     updatecompleter(mylist) 

   def membertosheet(self,member,partlist,wgtByPart,sh):
      
  
      row = 0
      col = 0
      for label in partlist:
         mylist = [[label,' Evaluated (Graded)']]
         k = (member, self.parts[label])
         if k in self.critByME.keys(): 
            for crit in self.critByME[k]:
               mylist.append( [crit.comment , '%.2f (%.2f)' % (crit.value,
                                          crit.value*wgtByPart[label])] )
         else:
               mylist.append( ['-' , '-'] )
         data2sh(mylist,sh,row,col)
         row += len(mylist) + 1

   def membertosheetpretty(self,member,partlist,wgtByPart,sh):
      
  
      row = 0
      col = 0
      sh.write(0,0,member.surname + ', ' + member.name)
      sh.write(0,1,member.nia)
      for label in partlist:
         mylist = [[label,' Evaluated (Graded)']]
         k = (member, self.parts[label])
         if k in self.critByME.keys(): 
            for crit in self.critByME[k]:
               mylist.append( [crit.comment , '%.2f (%.2f)' % (crit.value,
                                          crit.value*wgtByPart[label])] )
         else:
               mylist.append( ['-' , '-'] )
         data2shpretty(mylist,sh,row+2,col)
         row += len(mylist) + 1


    

   def __str__(self):
      uu = ''
      for part in self.parts.values():
         uu += '%20s - %s \n' % (' ', part.label)
         uu += '%20s    %s \n\n' % (' ', part.desc)
      a = """
             Evaluation Object  for %s
 -----------------------------------------------------
     Evaluation parts: 
%s

          """ % (self.name, uu)

      return a
   def corrector(self,askmember=False,force=False):
    
     print '--------------------------------------------'
     print 'Proceeding to evaluate the following members'
     print 
     for tm in self.members: print tm
     print '--------------------------------------------'
     print 'In the following order'
     print 
     i1 = 0
     for sublist in self.order:
        i1 +=1
        print '%d) %s' % (i1, ', '.join(sublist))
     print 
     print 

     
     if askmember: 
        mylist = []
        for tm in self.members:
           mylist.append(tm.surname)
        updatecompleter(mylist)
     self.updatecompleter()
     for sublist in self.order:
        i1 = -1
        while i1 < len(self.members)-1:
           i1 += 1
           if askmember: 
              print '***'
              print ' Introduce the surname of the student:'
              print
              surname = raw_input('>>>')
              member = findstudentinlist(surname, self.members)
              #if member is None: break
              if member is None:  
                 i1 = len(self.members)
                 continue
           else:
              member = self.members[i1]
           print
           print ' correcting %s:%s' % ( member.__class__.__name__, member)
           print
           for label in sublist:
              evalpart = self.parts[label] 
              if not (member,evalpart) in self.done or force:
                 # if the part,member exists, REMOVE
                 if (member, evalpart) in self.critByME.keys():
                    self.critByME[(member, evalpart)] = []
                 if evalpart.__class__.__name__ in ['EvalPart','TestPart']:
                    evalpart.correct(self,member)
                 elif evalpart.__class__.__name__ in ['TestVPart','TestVPartMulti']:
                    if member in self.versionByM.keys():
                       vers = self.versionByM[member]
                    else:
                       print '****'
                       print 
                       print 'Introduce the version of the test (Numbering starts at 1):'
                       print 
                       vers = int(raw_input('>>>'))
                       self.versionByM[member] = vers
                    evalpart.correct(self,member,vers)
              else:
                 print ' %s, %s ', (member.__class__.__name__, member.id), ' already corrected'
              self.done.append( (member, evalpart) )
              self.save()
              
   def isevaluated(self,member,partlist = None):
     if partlist is None:
        partlist = [item for item in self.parts.keys()]
     for label in partlist:
        if label in self.parts.keys():
           part = self.parts[label]
           if (member, part) in self.critByME.keys():
              return True
        else:
            print 'This label has not been evaluated'
     return False

   def getpresented(self, partlist = None):
      # return the list of members evaluated
      if partlist is None:
         partlist = [item for item in self.parts.keys()]
      presented = []
      for member in self.members:
         flag = self.isevaluated(member, partlist=partlist)
         if flag: presented.append(member)
      return presented


   def tovalue(self,tm,partlist, wgtByPart):
     tt = 0.
     for label in partlist:
        if label in self.parts.keys():
           part = self.parts[label]
           wgt = wgtByPart[label]
           if (tm, part) in self.critByME.keys():
              uu = 0.
              for crit in self.critByME[(tm,part)]:
                 uu += crit.value
              tt+=uu*wgt
     tt = max(tt,0.)
     return getfinalgrade(tt,1.)

   def getpass(self,partlist, wgtByPart,mingrade):
     nn = 0
     for member in self.members:
        gr = self.tovalue(member,partlist,wgtByPart)
        if gr >= mingrade: nn += 1
       
     return nn

   def getmean(self,part,wgt):
     # get mean value obtained in one part among all the 
     # students
     tt = 0.
     nn = 0
     for member in self.members:
        if (member, part) in self.critByME.keys():
           for crit in self.critByME[(member,part)]:
              tt += crit.value
        nn+=1
     tt = tt/float(nn)
     #return getfinalgrade(tt,1)
     return tt
   def getabsent(self):
     # get students not presented
     ntot = 0
     for member in self.members:
        nn = 0
        for part in self.parts.values():
           if (member, part) in self.critByME.keys():
              nn+=1
        if nn == 0: ntot+=1
     return ntot
   def toxls(self,partlist, wgtByPart, path=None,mingrade=5.0,members=None,suffix=''):
      if not path: path = self.path
      wb = xlwt.Workbook()
      
      if members is None: members = self.members
      # groups
      sh = wb.add_sheet('groups')
      irow=0
      icol=0

      row  = ['group','total']
      row += ['%s (%.2f)' % (label,wgtByPart[label]) for label in partlist]
      
      data2sh([row],sh,irow,icol) 

      irow=1
      icol=0
      for tm in members:
         if tm.__class__.__name__ == 'Group':
            row = [tm.gid,0.]
         elif tm.__class__.__name__ == 'Student':
            row = ['%s' % repr(tm),0.]
         tt = 0.
         for label in partlist:
            part = self.parts[label]
            wgt = wgtByPart[label]
            if (tm, part) in self.critByME.keys():
               uu = 0.
               for crit in self.critByME[(tm,part)]:
                  uu += crit.value
               #row += ['%.2f' % (uu*wgt)]
               row += [getfinalgrade(uu*wgt,2)]
               tt+=uu*wgt
            else:
               row += ['-']
         row[1] = getfinalgrade(tt,1)
         data2sh([row],sh,irow,icol) 
         irow+=1

      # STATISTICS 
      sh = wb.add_sheet('statistics')
      row=0
      col=0
      sh.write(row,col,'Statistics by part',header1)
      for label in partlist:
         row+=1
         part = self.parts[label]
         sh.write(row,col,part.label)
      #  --MEAN BY PART
      col+=1
      row = 0
      sh.write(row,col,'Mean',header1)
      for label in partlist:
         row+=1
         part = self.parts[label]
         wgt = wgtByPart[label]
         meanvalue = self.getmean(part,wgt)
         sh.write(row,col,meanvalue)
      #  -- GLOBAL QUANTIIES 
      meanvalue = 0.0
      for label in partlist:
         row+=1
         part = self.parts[label]
         wgt = wgtByPart[label]
         meanvalue += self.getmean(part,wgt)
      notp  = self.getabsent()
      npass = self.getpass(partlist,wgtByPart,mingrade)
      col+=3
      row =0
      sh.write(row,col  ,'Not presented',header1)
      sh.write(row,col+1,notp)
      row+=1
      sh.write(row,col  ,'Not presented (per)',header1)
      sh.write(row,col+1,100.*float(notp)/float(len(self.members)))
      row +=1
      sh.write(row,col  ,'Mean (among presented)',header1)
      sh.write(row,col+1,meanvalue)
      row +=1
      sh.write(row,col  ,'pass (among presented)',header1)
      sh.write(row,col+1,npass)
      row +=1
      sh.write(row,col  ,'per pass (among all)',header1)
      sh.write(row,col+1,100.*float(npass)/float(len(self.members)))

      # criteria
      sh = wb.add_sheet('criteria')
      row=0
      col=0
      for label in partlist:
         part = self.parts[label]
         part.tosheet(sh,row,col)
         sh.write(row+1,col+1, wgtByPart[label] )
         col+=3

   
      # detailed
      for tm in members:
         sh = wb.add_sheet('%s_%s' % (tm.__class__.__name__,tm.id))
         self.membertosheet(tm,partlist,wgtByPart,sh)

      wb.save(os.path.join(path,'evaluation_' + self.name + suffix + '.xls'))

   def reviewtoxls(self,partlist, wgtByPart,team, path=None):
      if not path: path = self.path
      wb = xlwt.Workbook()
      

      # criteria
      sh = wb.add_sheet('criteria')
      row=0
      col=0
      for label in partlist:
         part = self.parts[label]
         part.tosheet2(sh,row,col,self, team)
         sh.write(row,col+1, wgtByPart[label] )
         col+=3

   
      # detailed
      if team.__class__.__name__ == 'Group':
         sh = wb.add_sheet('team_%s' % team.gid)
         self.membertosheet(team,partlist,wgtByPart,sh)
         wb.save(os.path.join(path,'review_' + self.name + '_team' + team.gid + '.xls'))
      elif team.__class__.__name__ == 'Student':
         sh = wb.add_sheet('Student_%s' % team.nia)
         self.membertosheet(team,partlist,wgtByPart,sh)
         wb.save(os.path.join(path,'review_' + self.name + '_surname_' + team.surname + '_nia_' + team.nia + '.xls'))

   def fromxls(self,refgroup, path=None,suffix=''):

      #if refgroup is None: refgroup = self.members

      if not path: path = self.path
      wb=xlrd.open_workbook(os.path.join(path,'evaluation_%s%s.xls'%(self.name, suffix)))

      # criteria
      wgtByPart = {}
      sh = wb.sheet_by_name('criteria')
      row=0
      col=0
      classnm = sh.cell(row,col).value
      args    = sh.cell(row,col+1).value

      row +=1
      label = sh.cell(row,col).value
      desc  = sh.cell(row+1,col).value
      wgt   = float(sh.cell(row,col+1).value)
      gid = 0
      while label:
         print label, classnm
         if classnm == 'EvalPart':
            part = EvalPart(label,desc,gid)
         elif classnm == 'TestVPart':
            wrong = 0.0
            arglist = args.split(';')
            rightanswerlist = arglist[0].split(',')
            wrong = float(arglist[1])
            part = TestVPart(label,desc,gid,rightanswerlist,wrong=wrong)
         elif classnm == 'TestVPartMulti':
            wrong = 0.0
            arglist = args.split(';')
            rightanswerlist = []
            for ss in arglist[0].split(','):
               rightanswerlist += [ ss.split('.') ]
            wrong = float(arglist[1])
            part = TestVPartMulti(label,desc,gid,rightanswerlist,wrong=wrong)

         wgtByPart[label] = wgt

         critlist = []
         row+=2
         try:
            comment = sh.cell(row,col).value
         except:
            comment = ''
         while comment:
            if classnm == 'EvalPart':
               value   = float(sh.cell(row,col+1).value)
               crit = Criterion(comment,value)
            elif classnm in ['TestVPart','TestVPartMulti']: 
               answer = comment.split('-')[1]
               vers = comment.split('-')[0]
               vers = int(vers[1:])
               crit = part.evaluate(answer, vers)
            if not crit in critlist: critlist.append(crit)
            row+=1
            try:
               comment = sh.cell(row,col).value
            except:
               comment = ''




         part.criterions = critlist[:]
         self.parts[label] = part
         row=1
         col+=3
         try:
            classnm = sh.cell(row-1,col).value
            args    = sh.cell(row-1,col+1).value
            label = sh.cell(row,col).value
            desc  = sh.cell(row+1,col).value
            wgt   = float(sh.cell(row,col+1).value)
            gid+=1
         except:
            label=''
         print 'label = ', label

      # detailed
      shlist = []
      for sh in wb.sheets():
         if sh.name.startswith('team_'):
            gid = sh.name.split('team_')[1]
            tm = TeamGroup(gid)
         elif sh.name.startswith('Student_'):
            nia = sh.name.split('Student_')[1]
            tm = findstudent(nia,refgroup,'nia')
         else:
            continue
         self.addmembers([tm])
         row=0
         label = sh.cell(row,0).value
         part = self.parts[label]
         while label:
            row+=1
            try:
               comment = sh.cell(row,0).value
            except:
               comment = ''
         
            while comment:
               if nia == '100375117': print comment
               for crit in part.criterions:
                  if crit.comment == comment:
                     if not (tm,part) in self.critByME.keys():
                        self.critByME[(tm,part)] = []
                     self.critByME[(tm,part)].append(crit)
               row+=1
               try:
                  comment = sh.cell(row,0).value
               except:
                  comment = ''
            row+=1
            try:
               label = sh.cell(row,0).value
               part = self.parts[label]
            except:
               label = ''

                


class EvalPart:

   def __init__(self, label, desc, gid):
      self.label = label
      self.desc  = desc
      self.gid   = gid 
      self.criterions  = []
      self.valueByComment = {}

   def __eq__(self,other):
      a = self.label == other.label
      b = self.desc  == other.desc
      c = a and b
      return c
   def __hash__(self):
      return self.gid

   def evaluate(self, comment, value):

      crit = Criterion(comment, value)

      if not crit in self.criterions:
         self.criterions.append(crit)
         self.valueByComment[comment] = value

   def correct(self,mother,member):

      print
      print 80*'*'
      print 'part ', self    
      print 80*'*'
      print 'correcting group ', member
      print
      print 'previous criterions'
      print

      self.showprevious(color=True)
      if not (member,self) in mother.critByME.keys():
         mother.critByME[(member, self)] = []

      comment = raw_input('   comment ??   ')
      while comment:
         crit = Criterion(comment)
         if not crit in self.criterions:
            value = float(raw_input('   value ?    '))
         else:
            for crit2 in self.criterions:
               if crit == crit2:
                  value = crit2.value

         crit.value = value
         self.evaluate(comment,value)
         mother.updatecompleter()
         mother.critByME[(member, self)].append(crit)
         print
         comment = raw_input('   comment ??    ')

   def showprevious(self,color=False):
      for crit in self.criterions:
         crit.show(color)
      return

   def addfromother(self, other):
      for crit in other.criterions:
         if not crit in self.criterions: 
            self.criterions.append(crit)
            self.valueByComment[crit.comment] = crit.value

   def __str__(self):
      #return self.label  + '\n' + self.desc
      return bcolors.WARNING + self.label + bcolors.ENDC + '  ' + \
             bcolors.OKGREEN + self.desc + bcolors.ENDC 

   def tosheet(self,sh,row,col):
      sh.write(row,col  ,self.__class__.__name__,header1)
      row +=1
      sh.write(row,col,self.label,header1)
      sh.write_merge(row+1,row+1,col,col+1,self.desc,header1)
      i=2
      #for crit in self.criterions:
      #    sh.write(row+i,col  ,crit.comment,rower1arr[i%2])
      #    sh.write(row+i,col+1,crit.value,rower1arr[i%2])
      #    i+=1
      mylist = sorted([(crit.value,crit.comment) for crit in self.criterions])
      mylist = [[item[1],item[0]] for item in mylist]
      mylist.reverse()
      data2sh(mylist,sh,row+i,col)

   def tosheet2(self,sh,row,col,eval,team):
      sh.write(row,col,self.label,header1)
      sh.write_merge(row+1,row+1,col,col+1,self.desc,header1)
      i=2
      #for crit in self.criterions:
      #    sh.write(row+i,col  ,crit.comment,rower1arr[i%2])
      #    sh.write(row+i,col+1,crit.value,rower1arr[i%2])
      #    i+=1
      mylist = sorted([(crit.value,crit.comment) for crit in self.criterions])
      mylist = [[item[1],item[0]] for item in mylist]
      mylist.reverse()
      data2sh(mylist,sh,row+i,col)

      row += 3 + len(mylist)

      mylist = sorted([(crit.value,crit.comment) for crit in eval.critByME[(team, self)]])
      mylist = [[item[1],item[0]] for item in mylist]
      mylist.reverse()
      data2sh(mylist,sh,row+i,col)


class Criterion:
   def __init__(self, comment, value=0.0):
      self.comment = comment
      self.value = value

   def show(self, color=False):
      if color:
         print bcolors.OKBLUE + self.comment + bcolors.ENDC
         if self.value >= 0.:
            print bcolors.OKGREEN + '%70.2f' % self.value + bcolors.ENDC
         else:
            print bcolors.FAIL + '%70.2f' % self.value + bcolors.ENDC
      else:
         print self.comment 
         print  '%70.2f' % self.value 

   def __eq__(self,other):
      return self.comment == other.comment
      


class TestPart:

   def __init__(self, label, desc, gid, rightanswer):
      self.label = label
      self.desc  = desc
      self.gid   = gid 
      self.criterions  = []
      self.valueByComment = {}
      self.rightanswer=  rightanswer

   def __eq__(self,other):
      a = self.label == other.label
      b = self.desc  == other.desc
      c = a and b
      return c
   def __hash__(self):
      return self.gid

   def evaluate(self, answer):

      value = 0.0
      if answer == self.rightanswer:
          value = 1.0

      crit = Criterion(answer, value)
      if not crit in self.criterions:
         self.criterions.append(crit)
         self.valueByComment[answer] = value

      return crit

   def correct(self,mother,member):

      print
      print 'part ', self    

      if not (member,self) in mother.critByME.keys():
         mother.critByME[(member, self)] = []

      print
      print ' correcting %s:%s' % ( member.__class__.__name__, member)
      print

      answer = raw_input('   answer ?    ')

      crit = self.evaluate(answer)
      mother.critByME[(member, self)].append(crit)

      #mother.updatecompleter()

   def __str__(self):
      return self.label  + '\n' + self.desc

   def tosheet(self,sh,row,col):
      sh.write(row,col,self.label,header1)
      sh.write_merge(row+1,row+1,col,col+1,self.desc,header1)
      i=2
      #for crit in self.criterions:
      #    sh.write(row+i,col  ,crit.comment,rower1arr[i%2])
      #    sh.write(row+i,col+1,crit.value,rower1arr[i%2])
      #    i+=1
      mylist = sorted([(crit.value,crit.comment) for crit in self.criterions])
      mylist = [[item[1],item[0]] for item in mylist]
      mylist.reverse()
      data2sh(mylist,sh,row+i,col)

   ##def tosheet2(self,sh,row,col,eval,team):
   ##   sh.write(row,col,self.label,header1)
   ##   sh.write_merge(row+1,row+1,col,col+1,self.desc,header1)
   ##   i=2
   ##   #for crit in self.criterions:
   ##   #    sh.write(row+i,col  ,crit.comment,rower1arr[i%2])
   ##   #    sh.write(row+i,col+1,crit.value,rower1arr[i%2])
   ##   #    i+=1
   ##   mylist = sorted([(crit.value,crit.comment) for crit in self.criterions])
   ##   mylist = [[item[1],item[0]] for item in mylist]
   ##   mylist.reverse()
   ##   data2sh(mylist,sh,row+i,col)

   ##   row += 3 + len(mylist)

   ##   mylist = sorted([(crit.value,crit.comment) for crit in eval.critByME[(team, self)]])
   ##   mylist = [[item[1],item[0]] for item in mylist]
   ##   mylist.reverse()
   ##   data2sh(mylist,sh,row+i,col)

class TestVPart:

   def __init__(self, label, desc, gid, rightanswerlist,wrong=0.0):
      self.label = label
      self.desc  = desc
      self.gid   = gid 
      self.criterions  = []
      self.valueByComment = {}
      self.rightanswerlist=  rightanswerlist
      self.wrong = wrong 

   def __eq__(self,other):
      a = self.label == other.label
      b = self.desc  == other.desc
      c = a and b
      return c
   def __hash__(self):
      return self.gid

   def evaluate(self, answer,vers):

      if answer.lower().strip() == self.rightanswerlist[vers-1].lower().strip():
          value = 1.0
      elif len(answer) == 0:
         value = 0.0
      else:
         value = self.wrong

      crit = Criterion('v%d-%s' % (vers,answer), value)
      if not crit in self.criterions:
         self.criterions.append(crit)
         self.valueByComment['v%d-%s' % (vers,answer)] = value

      return crit

   def correct(self,mother,member,vers):

      print
      print 'part ', self    

      if not (member,self) in mother.critByME.keys():
         mother.critByME[(member, self)] = []

      print 'introduce the answer of the student'
      print
      answer = raw_input('>>>')


      crit = self.evaluate(answer,vers)
      mother.critByME[(member, self)].append(crit)

      #mother.updatecompleter()

   def __str__(self):
      return self.label  + '\n' + self.desc

   def tosheet(self,sh,row,col):

      mylist1= ['.'.join(item) for item in self.rightanswerlist]
      mystr1 = ','.join(mylist1)
      mystr2 = '%f' % (self.wrong)
      mystr = ';'.join([mystr1,mystr2])
      sh.write(row,col  ,self.__class__.__name__,header1)
      sh.write(row,col+1,mystr,header1)
      row +=1

      sh.write(row,col,self.label,header1)
      sh.write_merge(row+1,row+1,col,col+1,self.desc,header1)
      i=2
      #for crit in self.criterions:
      #    sh.write(row+i,col  ,crit.comment,rower1arr[i%2])
      #    sh.write(row+i,col+1,crit.value,rower1arr[i%2])
      #    i+=1
      mylist = sorted([(crit.value,crit.comment) for crit in self.criterions])
      mylist = [[item[1],item[0]] for item in mylist]
      mylist.reverse()
      data2sh(mylist,sh,row+i,col)

class TestVPartMulti:

   # rightanswerlistlist is a list of lists
   def __init__(self, label, desc, gid, rightanswerlist,wrong=0.0):
      self.label = label
      self.desc  = desc
      self.gid   = gid 
      self.criterions  = []
      self.valueByComment = {}
      aa = []
      for item in rightanswerlist:
          bb = []
          for answer in item:
              bb.append(answer.lower().strip())
          aa+=[bb]
      self.rightanswerlist=  aa
      self.wrong = wrong 

   def __eq__(self,other):
      a = self.label == other.label
      b = self.desc  == other.desc
      c = a and b
      return c
   def __hash__(self):
      return self.gid

   def evaluate(self, answer,vers):


      if answer.lower().strip() in self.rightanswerlist[vers-1]:
          value = 1.0
      elif len(answer) == 0:
         value = 0.0
      else:
         value = self.wrong

      crit = Criterion('v%d-%s' % (vers,answer), value)
      if not crit in self.criterions:
         self.criterions.append(crit)
         self.valueByComment['v%d-%s' % (vers,answer)] = value

      return crit

   def correct(self,mother,member,vers):

      print
      print 'part ', self    

      if not (member,self) in mother.critByME.keys():
         mother.critByME[(member, self)] = []

      print 'introduce the answer of the student'
      print
      answer = raw_input('>>>')


      crit = self.evaluate(answer,vers)
      mother.critByME[(member, self)].append(crit)

      #mother.updatecompleter()

   def __str__(self):
      return self.label  + '\n' + self.desc

   def tosheet(self,sh,row,col):

      mylist = ['.'.join(item) for item in self.rightanswerlist]
      mystr1 = ','.join(mylist)
      mystr2 = '%f' % (self.wrong)
      mystr = ';'.join([mystr1,mystr2])
      sh.write(row,col  ,self.__class__.__name__,header1)
      sh.write(row,col+1,mystr,header1)
      row +=1

      sh.write(row,col,self.label,header1)
      sh.write_merge(row+1,row+1,col,col+1,self.desc,header1)
      i=2
      #for crit in self.criterions:
      #    sh.write(row+i,col  ,crit.comment,rower1arr[i%2])
      #    sh.write(row+i,col+1,crit.value,rower1arr[i%2])
      #    i+=1
      mylist = sorted([(crit.value,crit.comment) for crit in self.criterions])
      mylist = [[item[1],item[0]] for item in mylist]
      mylist.reverse()
      data2sh(mylist,sh,row+i,col)
