import os
from xlwt import Workbook,Formula
from mygrades.xls import header1, right1arr,right2arr,rower1arr, rower2arr
from mytext import updatecompleter
from mylist import sublists
from math import floor

def evaluator(crt,grp,valByCrit,commByCrit,desc=''):
    """
    Function that evaluates ctriteria crt of group grp.
    Print on screen previous values given to specific comments
     on that criteria.
    If any new comment is done, commentsByCriteria(commByCrit)
     is updated to show it in the following evaluations.
    Returns val, com, and updated valByCrit, comBycrit
    """
    if crt in commByCrit.keys():
      if len(commByCrit[crt]) > 0: 
         print 
         print '_______________  PREVIOUS NOTES ___________'
         for j in range(len(commByCrit[crt])):
            print 
            print '\t\t\t' +commByCrit[crt][j].replace('_',' '), valByCrit[crt][j]  
         print 
    else:
      commByCrit[crt]=[]
      valByCrit[crt]=[]
    updatecompleter(commByCrit[crt])
    val = 'kk'
    while val == 'kk':
       try:
         valcom = raw_input('\t\t%30s :   ' % crt).split()
         if not valcom:
              print
              print desc
              print
              val == 'kk'
         else:
           val = float(valcom[0])
       except:
         if '_'.join(valcom) in commByCrit[crt]:
             for ii2 in range(len(commByCrit[crt])):
                if commByCrit[crt][ii2] == '_'.join(valcom):
                   com = '_'.join(valcom)
                   val = valByCrit[crt][ii2]
         else:
             print 'introduzca un numero'
    #
    if len(valcom) > 1:
         com = ' '.join(valcom[1:]).replace(' ','_')
    else:
         com = ' '.join(valcom).replace(' ','_')
    #
    if not com in commByCrit[crt] and com:
       commByCrit[crt].append(com)
       valByCrit[crt].append(val)
    #
    return val, com, valByCrit, commByCrit

def corrector(criterias0,save=True,fname='grades.py',descriptionByCrit={}):
   """
   Function to evaluate criterias defined in list criterias0.
   Saves a comment and a value for every criteria and id evaluated in
    dictionaries commByCritByGroup and valByCritByGroup in file fname.
   Makes savings at bak file.
   The saving is done in appending mode.
   If save is set to False, do not save results. 
   """ 
   # initialize data
   commByCrit        = {} 
   valByCrit         = {}
   commByCritByGroup = {}
   valByCritByGroup  = {}

   # import data from fname if it exists
   if fname in os.listdir('.'):
       #execfile(fname)       
       mymodule = __import__(fname.replace('.py',''))
       commByCrit        = mymodule.commByCrit        
       valByCrit         = mymodule.valByCrit         
       commByCritByGroup = mymodule.commByCritByGroup 
       valByCritByGroup  = mymodule.valByCritByGroup  
   # start correcting
   while 2>1:
      grp = raw_input('\tgroup name :')
      print 
      # if grp is empty, finish
      if grp:
        if grp not in commByCritByGroup.keys():
           commByCritByGroup[grp] = {} 
           valByCritByGroup[grp] = {}
        i=0
        criterias=criterias0
        while i < len(criterias0):
           #
           updatecompleter(criterias)
           crt='kk'
           while not crt in criterias and crt:
              crt=raw_input('\t\tintroduce criteria: ')
           print 
           # if sth is introduced, evaluate
           if crt:
              desc =''
              if crt in descriptionByCrit.keys():
                  desc=descriptionByCrit[crt]
              val,com,valByCrit,commByCrit=evaluator(crt,grp,valByCrit,commByCrit,desc)
              commByCritByGroup[grp][crt] = com
              valByCritByGroup[grp][crt] = val
              # if nth is introduced, continue pending list
              criterias = sublists(criterias,[crt])
              i+=1
           else:
              for crt in criterias:
                desc =''
                if crt in descriptionByCrit.keys():
                    desc=descriptionByCrit[crt]
                val,com,valByCrit,commByCrit=evaluator(crt,grp,valByCrit,commByCrit,desc)
                commByCritByGroup[grp][crt] = com
                valByCritByGroup[grp][crt] = val
                i+=1
        # BACKUP
        f=open('data.bak','w')
        mystring = repr(commByCritByGroup).replace(')',')        \n').replace(']',']\n')
        f.write('commByCritByGroup = '+mystring+'\n')
        mystring= repr(valByCritByGroup).replace(')',')        \n').replace(']',']\n')
        f.write('valByCritByGroup = '+mystring+'\n')
        mystring = repr(commByCrit).replace(')',')        \n').replace(']',']\n')
        f.write('commByCrit = '+mystring+'\n')
        mystring= repr(valByCrit).replace(')',')        \n').replace(']',']\n')
        f.write('valByCrit = '+mystring+'\n')
        f.close()
      # exit
      else:
         break
   if save:
       f=open(fname,'w')
       mystring = repr(commByCritByGroup).replace('},','},\n').replace(']',']\n')
       f.write('#______commByCritByGroup_________#\n')
       f.write('commByCritByGroup = '+mystring+'\n')
       mystring= repr(valByCritByGroup).replace('},','},       \n').replace(']',']\n')
       f.write('#______valByCritByGroup_________#\n')
       f.write('valByCritByGroup = '+mystring+'\n')
       mystring = repr(commByCrit).replace(')',')        \n').replace(']',']\n')
       f.write('#______commByCrit________________#\n')
       f.write('commByCrit = '+mystring+'\n')
       mystring= repr(valByCrit).replace(')',')        \n').replace(']',']\n')
       f.write('#______valByCrit________________#\n')
       f.write('valByCrit = '+mystring+'\n')
       f.close()

def grades2wb(valByCritByGroup,commByCritByGroup,
              criterias='*',groups='*',wgtByCrit='*',
              bookName  = 'grades', book=None, label='', write=True):
   """
   Function to generate .xls file with evalutaion information
    contained in valByCritByGroup and commByCritByGroup dicts.
   If not given criterias or groups, built from val and comm dicts.
   If not given wgtByCrit, not weight of criterias given.
   """
   #   groups list 
   if groups == '*':
       groups = []
       for grp in sorted(valByCritByGroup.keys()):
          groups.append(grp)
          # CHECK
          if not grp in commByCritByGroup.keys():
             print 
             print 'group ' + grp + ' not in both dictionaries'
             print 
             return
   #   criteria list
   if criterias == '*':
       criterias = []
       for crt in sorted(valByCritByGroup[grp].keys()):
          criterias.append(crt)
          # CHECK
          if not crt in commByCritByGroup[grp].keys():
             print 
             print 'criteria ' + crt + ' not in both dictionaries'
             print 
             return
   # weights of criterias. Default set to zero
   if wgtByCrit == '*':
       wgtByCrit = {}
       for crt in sorted(valByCritByGroup[grp].keys()):
          wgtByCrit[crt] = 0.
   # 
   if book is None: book = Workbook()
   # _____________ criteria and weights sheet ___________________________________________
   sh = book.add_sheet('%s_weights' % label)    
   #
   row = 1 
   critcol = 1
   wgtcol  = 2
   sh.write(row,critcol, 'CRITERIA',header1)
   sh.write(row,wgtcol, 'WEIGHT',header1)
   #
   row+=1
   for crt in criterias:
       wgt = wgtByCrit[crt]
       sh.write(row,critcol, crt,rower1arr[row%2])
       sh.write(row,wgtcol,  wgt,right1arr[row%2])
       row+=1
   # _____________ evaluation sheet _____________________________________________________
   sh = book.add_sheet('%s_eval' % label)    
   # 
   sh.write(1,1, 'GROUP',header1)
   # crierias row
   row    = 1
   crtcol = 2
   for crt in criterias:  
       sh.write_merge(row,row,crtcol,crtcol+1,crt,header1)
       crtcol+=2
   # groups column
   row    = 2
   grpcol = 1
   for grp in groups:  
       sh.write(row,grpcol, grp,rower1arr[row%2])
       row+=1
   # values and comments
   row    = 2
   for grp in groups:  
      crtcol = 2
      for crt in criterias:
        sh.write(row,crtcol,valByCritByGroup[grp][crt],right1arr[row%2])
        sh.write(row,crtcol+1,commByCritByGroup[grp][crt],right2arr[row%2])
        crtcol+=2
      row+=1 
   # _____________ grades sheet _____________________________________________________
   sh = book.add_sheet('%s_grades' % label)    
   sh.write(1,1, 'GROUP',header1)
   # crierias row
   sh.write(1,2,'TOTAL',header1)
   row    = 1
   crtcol = 3
   for crt in criterias:  
       sh.write(row,crtcol,crt,header1)
       crtcol+=1
   # groups column
   row    = 2
   grpcol = 1
   for grp in groups:  
       sh.write(row,grpcol, grp,rower1arr[row%2])
       row+=1
   # values and comments
   A = ord('A')
   #mystring = []
   row    = 2
   grpi = 2
   for grp in groups:  
      crtcol = 3
      crti=0
      for crt in criterias:
        #uu = 'eval!%s%d*weights!%s%d'% (chr(A+crti*2+2),grpi+1,chr(A+2),crti+3)
        uu = '%s_eval!%s%d*%s_weights!%s%d'% (label,excelletters(crti*2+2),grpi+1,label,\
              excelletters(2),crti+3)
        sh.write(row,crtcol,Formula(uu),right1arr[row%2])
        #mystring.append(uu) 
        crti+=1
        crtcol+=1
      #sh.write(row,2,Formula('SUM(%s%d:%s%d)' % ( excelletters(3) , row+1, excelletters(crtcol) ,row+1)),rower2arr[row%2])
      sh.write(row,2,Formula('SUM(%s%d:%s%d)' % ( excelletters(3) , row+1, excelletters(crtcol-1) ,row+1)),rower2arr[row%2])
      grpi+=1
      row+=1 
   if write: book.save(bookName+'.xls')
   else: return book

def excelletters(index):
   maxlett=26
   i1 = index%maxlett
   i0 = (index-i1)/maxlett
   if i0 == 0:
      return chr(ord('A')+i1)
   else:
      return chr(ord('A')+i0-1)+chr(ord('A')+i1)
