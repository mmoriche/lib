from mygrades.grades import corrector,grades2wb
# CRITERIAS FOR THE LAB
criterialist = ['introduction',
 '1deg sys',
 'description numerical',
 'description analytical',
 'description analytical numerial relation',
 'results numerical',
 'results analytical',
 'discussion limits',  
 'discussion type',  
 'discussion singularity',  
 'conclusion numerical checked by analytical',
 'penalization grammar',
 'penalization units',
 'extra point for work']

descrByCrit = {'introduction': 'Just a brief introduction about the lab',
 '1deg sys': 'Pose the 1st order ode system to integrate by numerical methods',
 'description numerical':'Decribe the numerical integration procedure',
 'description analytical':'Decribe the analytical analysis',
 'results numerical':'Movement clearly described by plots',
 'results analytical':'Movement clearly described by plots',
 'discussion limits':'Nutation limits from analytical correspond to numerical results',  
 'discussion type':'theta vs psi corresponds to analytical outcome  for the type of movement',  
 'conclusion numerical vs analytical':'comments about the analytical check of the numerical solution',
 'penalization grammar':'',
 'penalization units':'',
 'extra point for work':''}


wgtByCrit = {'introduction':1.0,
 '1deg sys':0.4,
 'description numerical':0.4,
 'description analytical':0.4,
 'description analytical numerial relation':0.4,
 'results numerical':1.5,
 'results analytical':1.5,
 'discussion limits':1.5,  
 'discussion type':1.5,  
 'discussion singularity':0.4,  
 'conclusion numerical checked by analytical':1.0,
 'penalization grammar':1.0,
 'penalization units':1.0,
 'extra point for work':1.0}

# CRITERIAS
if __name__=='__main__':
   corrector(criterialist,descriptionByCrit=descrByCrit)

   mymod = __import__('grades')
   valByCritByGroup=mymod.valByCritByGroup
   commByCritByGroup=mymod.commByCritByGroup
   
   grades2wb(valByCritByGroup, commByCritByGroup,\
             criterias=criterialist,\
             wgtByCrit=wgtByCrit)

