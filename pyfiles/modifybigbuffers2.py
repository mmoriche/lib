import os, shutil, glob
import h5py
import numpy as np

project='data/IBcode/rafagas/production_3D'
dataset=['']
# 09.10.2019 # basenm='MASF_2003'
basenmlist=['AG200w200_2D_small_NC128', 
'AG200w200_3D_small_NC128_LZC04', 
'AG200w200_3D_small_NC128_LZC04BACKUP', 
'AG200w200_3D_small_NC128_LZC04_optsolver', 
'AG200w200_3D_small_NC256_LZC04', 
'AG200w200_3D_tight_NC256_LZC04', 
'AG200w200_3D_tight_NC320_LZC04_kwake0001m_r0400c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0001m_r0600c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0001m_r0800c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0001m_r1000c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0001m_r1200c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0002m_r0400c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0002m_r0600c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0002m_r0800c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0002m_r1000c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0002m_r1200c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0004m_r0400c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0004m_r0600c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0004m_r0800c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0004m_r1000c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0004m_r1200c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0008m_r0400c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0008m_r0600c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0008m_r0800c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0008m_r1000c', 
'AG200w200_3D_tight_NC320_LZC04_kwake0008m_r1200c', 
'AG200w200_3D_tight_NC320_LZC04_OPTSOLVER', 
'AG200w200_3D_tight_NC320_LZC05', 
'AG200w200_3D_tight_NC320_LZC05_optsolver', 
'AG200w200_3D_tight_NC320_LZC05_r0100c', 
'AG200w200_3D_tight_NC320_LZC05_r0150c', 
'AG200w200_3D_tight_NC320_LZC05_r0200c', 
'AG200w200_3D_tight_NC320_LZC05_r0300c', 
'AG200w200_3D_tight_NC320_LZC05_r0400c', 
'AG200w200_3D_tight_NC320_LZC05_r0450c', 
'AG200w200_3D_tight_NC320_LZC05_r0500c', 
'AG200w200_3D_tight_NC320_LZC05_r0550c', 
'AG200w200_3D_tight_NC320_LZC05_r0600c', 
'AG200w200_3D_tight_NC320_LZC05_r0800c', 
'ST050_3D_NC320_LZC04', 
'ST050_3D_NC320_LZC04_kwake000125cm_r0400c', 
'ST050_3D_NC320_LZC04_kwake000125cm_r0600c', 
'ST050_3D_NC320_LZC04_kwake000125cm_r0800c', 
'ST050_3D_NC320_LZC04_kwake000125cm_r1000c', 
'ST050_3D_NC320_LZC04_kwake000125cm_r1200c', 
'ST050_3D_NC320_LZC04_kwake000250cm_r0400c', 
'ST050_3D_NC320_LZC04_kwake000250cm_r0600c', 
'ST050_3D_NC320_LZC04_kwake000250cm_r0800c', 
'ST050_3D_NC320_LZC04_kwake000250cm_r1000c', 
'ST050_3D_NC320_LZC04_kwake000250cm_r1200c', 
'ST050_3D_NC320_LZC04_kwake000500cm_r0400c', 
'ST050_3D_NC320_LZC04_kwake000500cm_r0600c', 
'ST050_3D_NC320_LZC04_kwake000500cm_r0800c', 
'ST050_3D_NC320_LZC04_kwake000500cm_r1000c', 
'ST050_3D_NC320_LZC04_kwake000500cm_r1200c', 
'ST050_3D_NC320_LZC04_kwake001000cm_r0400c', 
'ST050_3D_NC320_LZC04_kwake001000cm_r0600c', 
'ST050_3D_NC320_LZC04_kwake001000cm_r0800c', 
'ST050_3D_NC320_LZC04_kwake001000cm_r1000c', 
'ST050_3D_NC320_LZC04_kwake001000cm_r1200c', 
'ST050_3D_small_NC128_LZC04', 
'ST050_3D_tight_NC128_LZC04', 
'ST050_3D_tight_NC256_LZC02', 
'ST050_3D_tight_NC256_LZC04', 
'ST050_3D_tight_NC320_LZC02']

tank=os.environ['TANK_PATH']

for basenm in basenmlist:

   #ipatt=os.path.join(tank,project,'/'.join(dataset),basenm, '*.h5flo')
   #bigbuffers = ['ux_re','uy_re','uz_re','p_re', 
   #              'ux_im','uy_im','uz_im','p_im']
   ipatt=os.path.join(tank,project,'/'.join(dataset),basenm, '*.h5frame')
   bigbuffers = ['ux','uy','uz','p','ux0','uy0','uz0','p0']
   
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

   
 
 
