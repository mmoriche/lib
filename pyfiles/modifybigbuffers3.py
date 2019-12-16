import os, shutil
import h5py
import numpy as np

project='data/IBcode/MAS'
dataset=['']
# 09.10.2019 # basenm='MASF_2003'
basenm='MASF_1003_FLO_0100'
ifrbeg=0
ifrend=768



tank=os.environ['TANK_PATH']

#ipatt=os.path.join(tank,project,'/'.join(dataset),'{basenm:s}/{basenm:s}.{ifr:07d}.h5frame')
#bigbuffers = ['ux','uy','uz','p','ux0','uy0','uz0','p0']

ipatt=os.path.join(tank,project,'/'.join(dataset),'{basenm:s}/{basenm:s}.{ifr:07d}.h5flo')
bigbuffers = ['ux_re','uy_re','uz_re','p_re', 
              'ux_im','uy_im','uz_im','p_im']

tpatt=os.path.join(tank,'{basenm:s}_TMP.h5')
bpatt=os.path.join(tank,'{basenm:s}_BAK.h5')

d4='<f4'

n=0
# LAST FILE NOT MODIFIED # for ifr in range(ifrbeg,ifrend+1): 
for ifr in range(ifrbeg,ifrend): 
   ifnm=ipatt.format(basenm=basenm,ifr=ifr)
   tfnm=tpatt.format(basenm=basenm,ifr=ifr)
   bfnm=bpatt.format(basenm=basenm,ifr=ifr)

   print 'processing', ifr

   if not os.path.isfile(ifnm): 
      print 'input file does not exist'
      print ifnm
      exit(1)
   else:
      print ifnm
    
   fr = h5py.File(ifnm,'r')
   ftmp = h5py.File(tfnm,'w')
 
   keylist = fr.keys()

   bigbuffers_modified = []
   for key in keylist:
   
      s = fr[key].shape
      v = fr[key].value
      d = fr[key].dtype

      if key in bigbuffers and d.itemsize==8:
         print 'modifying ',key,'===================================' 
         print key,s,d
         ftmp.create_dataset(key,s,d4,data=v.astype(d4))
         bigbuffers_modified.append(key)
      else:
         print 'copying ',key
         ftmp.create_dataset(key,s,d,data=v)
 
   fr.close()
   ftmp.close()


   # CHECK BIG BUFFERS
   f1 = h5py.File(ifnm,'r')
   f2 = h5py.File(tfnm,'r')
   dummy=-1.0
   for buff in bigbuffers_modified:
      #onedummy=np.max(np.abs((f1[buff].value-f2[buff].value)/f1[buff].value))
      onedummy=np.max(np.abs((f1[buff].value-f2[buff].value)))
      print buff, onedummy
      dummy=np.max([onedummy,dummy])
   
   print 'max diff = ', dummy
   f1.close()
   f2.close()


   if dummy > 5e-7:
      print 'Error is greater than expected'
      exit(1)

   print 'moving ', ifnm, ' to ', bfnm    
   shutil.move(ifnm,bfnm)
   print 'moving ', tfnm, ' to ', ifnm
   shutil.move(tfnm,ifnm)

   
 
 
