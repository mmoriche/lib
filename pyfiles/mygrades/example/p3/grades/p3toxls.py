
from mygrades.grades import grades2wb

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

mymod = __import__('grades')
valByCritByGroup=mymod.valByCritByGroup
commByCritByGroup=mymod.commByCritByGroup

grades2wb(valByCritByGroup, commByCritByGroup,criterias=criterialist)

