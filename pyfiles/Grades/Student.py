# -*- coding: utf-8 -*-
import pickle
import os
import xlwt

class UniMember:
   def __init__(self, name, surname, id): 
      self.surname = surname
      self.name = name
      self.id = id

class KITStudent(UniMember):
   def __init__(self, name, surname, nia):
      UniMember.__init__(self, name, surname, nia)
      self.mail = u'%s@students.kit.edu' % nia 
      self.nia = nia
      self.team = u'XXX'
      self.id = nia

   def __repr__(self):
      aa = '%20s%20s%30s%30s' % (self.nia, self.name, self.surname, self.mail)
      return unicode(repr(aa),'utf-8')

   def __str__(self):
      return u'%s' % self.__repr__()
   def __unicode__(self):
      return u'%s' % self.__repr__()

   def __eq__(self, other):
      if self.nia == other.nia: return True
      return False
   def __hash__(self):
      return int(self.nia)

   def findteam(self, LabGroup):
       for team in LabGroup.groups:
           if self in team.students:
	      self.team = team.gid
class Student(UniMember):
   def __init__(self, name, surname, nia):
      UniMember.__init__(self, name, surname, nia)
      self.mail = u'%s@alumnos.uc3m.es' % nia 
      self.nia = nia
      self.team = u'XXX'
      self.id = nia

   def __repr__(self):
      aa = '%20s%20s%30s%30s' % (self.nia, self.name, self.surname, self.mail)
      return unicode(repr(aa),'utf-8')

   def __str__(self):
      return u'%s' % self.__repr__()
   def __unicode__(self):
      return u'%s' % self.__repr__()

   def __eq__(self, other):
      if self.nia == other.nia: return True
      return False
   def __hash__(self):
      return int(self.nia)

   def findteam(self, LabGroup):
       for team in LabGroup.groups:
           if self in team.students:
	      self.team = team.gid

class Group:
   def __init__(self, gid='', students=[],label='g'):
      self.gid = gid # identification of group
      self.students = students[:]
      self.label = label

   def save(self,path='.',frmt=None):
      if not frmt: frmt = self.label + '%s.pkl'
      output = open(os.path.join(path,frmt % (self.gid)),'wb')
      pickle.dump(self, output, -1)
      output.close()

   def load(self,path='.',frmt=None):
      if not frmt: frmt = self.label + '%s.pkl'
      output = open(os.path.join(path,frmt % str(self.gid)),'rb')
      group = pickle.load(output)
      output.close()
      self.gid      = group.gid
      self.students = group.students[:]

   def sorted(self, field='surname'):
      a = [getattr(st,field) for st in self.students]
      b = zip(a,self.students)
      students = [item[1] for item in b] 
      
      return Group(self.gid, students=students)


   def isnotcontainedin(self,other):
      stlist = []
      for st in self.students:
         if not st in other.students:
            stlist.append(st)
      return Group(gid='%s_not_in_%s' % (self.gid,other.gid),students=stlist)

   def contains(self, other):
      for st in other.students:
          if not st in self.students:
             return False
      return True

   def __add__(self, other):
      if not self.gid:
         gid = '%s' % other.gid
      elif not other.gid:
         gid = '%s' % self.gid
      else:
         gid = '%s+%s' % (self.gid, other.gid)
      students = self.students+other.students
      return Group(gid,students)

   def printfields(self,fields=['name','surname']):
      lnbyfield = {'name':20, 'surname':30}
      a = u'\n'
      a += u'group %s\n ' % self.gid
      a += u'\n'
      for st in self.students:
         for fld in fields:
            frmt = u'%' + unicode(str(lnbyfield[fld])) + u's'
            a += frmt % getattr(st,fld)
         a += u'\n'
      return a

   def __repr__(self):
      a = u'\n'
      a += u'group %s\n ' % self.gid
      a += u'\n'
      for st in self.students:
         #print st.name, st.surname
         a += u'%s' % Student.__repr__(st)
         a += u'\n'
      return a
   def __str__(self):
      return u'%s' % self.__repr__()
   def __unicode__(self):
      return u'%s' % self.__repr__()

   def __eq__(self, other):
      return self.gid == other.gid
   def __hash__(self):
      return int(self.gid)

class TeamGroup(Group):
   def __init__(self, gid='', students = [],label = 'team'):
      Group.__init__(self, gid, students,label=label)
   def __str__(self):
      return '%s' % self.gid

class MagGroup(Group):
   def __init__(self, gid='', students = [],label = 'mag'):

      Group.__init__(self, gid, students,label=label)

class LabGroup(Group):
   def __init__(self, gid='', students = [], groups=[],label='lab'):

      Group.__init__(self, gid, students,label=label)
      self.groups = groups[:]

   def toxls_a(self,path='.',frmt=None,wb=None):
      if not frmt: frmt = self.label + '%s_a.xls'
      if not wb: wb = xlwt.Workbook()
      sh = wb.add_sheet('Lab Group %s a' % self.gid)
      sh.write(0,0,'NIA')
      sh.write(0,1,'Name')
      sh.write(0,2,'Surname')
      sh.write(0,3,'Team')
      sh.write(0,4,'mail')
      irow = 1
      for st in self.students:
         sh.write(irow,0,st.nia)
         sh.write(irow,1,st.name)
         sh.write(irow,2,st.surname)
         #sh.write(irow,2,u'ñ')
         st.findteam(self)
         sh.write(irow,3,st.team)
         sh.write(irow,4,st.mail)
	 irow+=1
      wb.save(frmt%self.gid)

   def toxls_b(self, path='.',frmt=None,wb=None):
      if not frmt: frmt = self.label + '%s_b.xls'
      if not wb: wb = xlwt.Workbook()
      sh = wb.add_sheet('Lab Group %s b' % self.gid)

      sh.write(0,0,'Team')
      sh.write(0,1,'Group')
      irow = 1
      for team in self.groups:
         sh.write(irow,0,team.gid)
         sh.write(irow,1,self.gid)
         irow+=1
          
      wb.save(frmt%self.gid)


def findstudent(key,group,field='surname',insist=True):

    findings = []
    key = key.replace(u' ',u'').lower()
    for st in group.students: 
       ref = getattr(st, field )
       ref = ref.replace(u' ',u'').lower()
       if ref.startswith(key): findings.append(st)

    if len(findings) == 1:
       return findings[0]
    elif insist:
       print 'wanna enter different key?'
       print '%d findings for %s:%s' % (len(findings),field,key)
       print 
       if len(findings) > 0:
          for st2 in findings:
             print st2
       print 'enter      - exit'
       print 'key        - new key'
       print 'field, key - new field, new key'
       uu = raw_input()
       if ',' in uu:
           field,key = uu.split(',')
       elif uu:
           key = uu
       else:
           return
       st = findstudent(key,group,field)
    else:
        return

def findstudentinlist(key,members,field='surname'):

    while True:
       findings = []
       key = key.replace(u' ',u'').lower()
       for st in members: 
          ref = getattr(st, field )
          ref = ref.replace(u' ',u'').lower()
          if ref.startswith(key): findings.append(st)
       if len(findings) == 1: break
       print 'wanna enter different key?'
       print '%d findings for %s:%s' % (len(findings),field,key)
       print 
       if len(findings) > 0:
          for st2 in findings:
             print st2
       print 'enter      - exit'
       print 'key        - new key'
       print 'field, key - new field, new key'
       uu = raw_input()
       if ',' in uu:
           field,key = uu.split(',')
       elif uu:
           key = uu
       else:
           return
    return findings[0]
def findstudentinlist_mk(keylist,members,fields=['surname','name']):

    while True:
       findings = []
       for i1 in range(len(keylist)):
          keylist[i1] = keylist[i1].replace(u' ',u'').lower()
       for st in members: 
          n = 0
          for i1 in range(len(fields)):
             key = keylist[i1]
             field = fields[i1]
             ref = getattr(st, field )
             ref = ref.replace(u' ',u'').lower()
             if ref.startswith(key): n+=1
          if n == len(fields):  findings.append(st)
       if len(findings) == 1: break
       print 'wanna enter different key?'
       print '%d findings for %s:%s' % (len(findings),field,key)
       print 
       if len(findings) > 0:
          for st2 in findings:
             print st2
       print 'enter      - exit'
       print 'key        - new key'
       print 'field, key - new field, new key'
       uu = raw_input()
       if ',' in uu:
           field,key = uu.split(',')
       elif uu:
           key = uu
       else:
           return
    return findings[0]
