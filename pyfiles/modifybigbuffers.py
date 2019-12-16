import os, shutil, glob
import h5py
import numpy as np

project='data/IBcode/MAS'
dataset=['']
# 09.10.2019 # basenm='MASF_2003'
basenmlist=['MASF_0000'
'MASF_0000', 
'MASF_0001', 
'MASF_0002', 
'MASF_0003', 
'MASF_0004', 
'MASF_0005', 
'MASF_1000', 
'MASF_1001', 
'MASF_1002', 
'MASF_1002_LR_2DT', 
'MASF_1002_LR_2DT_BIG', 
'MASF_1003', 
'MASF_1004', 
'MASF_1005', 
'MASF_2000', 
'MASF_2001', 
'MASF_2002', 
'MASF_2003', 
'MASF_2003_2DT', 
'MASF_2003_HR', 
'MASF_2003_HR.h5res', 
'MASF_2003_LR', 
'MASF_2003_LR_2DT', 
'MASF_2003_LR_MESHEU', 
'MASF_2003_random_1', 
'MASF_2003_random_2', 
'MASF_2003_random_scratch_1', 
'MASF_2003_random_scratch_2', 
'MASF_2004', 
'MASF_2005', 
'MASF3D_1002', 
'MASF3D_1002_128.h5res', 
'MASF3D_1002_64F', 
'MASF3D_1002_64F.h5res', 
'MASF3D_2003', 
'MASF3D_2003_213.h5res', 
'MASF3D_2003_256.h5res', 
'MASF3D_2003_SCALE_144', 
'MASF3D_2003_SCALE_36', 
'MASF3D_2003_SCALE_72', 
'NACA0012_POT', 
'NACA0012_POT_31', 
'NACA0012_POT_s']

tank=os.environ['TANK_PATH']

for basenm in basenmlist:

   ipatt=os.path.join(tank,project,'/'.join(dataset),basenm, '*.h5frame')
   bigbuffers = ['ux','uy','uz','p','ux0','uy0','uz0','p0']
   
   #ipatt=os.path.join(tank,project,'/'.join(dataset),'{basenm:s}/{basenm:s}.{ifr:07d}.h5flo')
   #ipatt=os.path.join(tank,project,'/'.join(dataset),basenm, '*.h5flo')
   #bigbuffers = ['ux_re','uy_re','uz_re','p_re', 
   #              'ux_im','uy_im','uz_im','p_im']
   
   tfnm=os.path.join(tank,'%s_TMP.h5' % (basenm,))
   bfnm=os.path.join(tank,'%s_BAK.h5' % (basenm,))
   
   d4='<f4'
   
   n=0
   # LAST FILE NOT MODIFIED # for ifr in range(ifrbeg,ifrend+1): 
   #for ifr in range(ifrbeg,ifrend): 
   #flist=os.listdir(ipatt)
   flist=sorted(glob.glob(ipatt))
   
   for i0 in range(len(flist)-1):
      ifnm=flist[i0]
   
      print 'processing', ifnm
   
      if not os.path.isfile(ifnm): 
         print 'input file does not exist'
         print ifnm
         exit(1)
      else:
         print ifnm
       
      fr = h5py.File(ifnm,'r')

      keylist = fr.keys()
      flag = []
      for key in keylist:
      
         s = fr[key].shape
         if np.max(s) == 0: continue
         d = fr[key].dtype
   
         if key in bigbuffers and d.itemsize==8:
            flag.append(key)

      if len(flag)==0:
         fr.close()
         continue

      ftmp = h5py.File(tfnm,'w')
    
      keylist = fr.keys()
   
      bigbuffers_modified = []
      for key in keylist:
      
         s = fr[key].shape
         if np.max(s) == 0: continue
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
         onedummy1=np.max(np.abs((f1[buff].value-f2[buff].value)/f1[buff].value))
         onedummy2=np.max(np.abs((f1[buff].value-f2[buff].value)))
         onedummy=min(onedummy1,onedummy2)
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

   
 
 
