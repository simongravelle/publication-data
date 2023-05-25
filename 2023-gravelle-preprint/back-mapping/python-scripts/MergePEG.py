#!/usr/bin/env python
# coding: utf-8

# In[1]:


from shutil import rmtree
import MDAnalysis as mda
import numpy as np
import warnings
import os
warnings.filterwarnings('ignore')


# In[2]:


# detect number of frames
frame = 0
frame_list = []
found = True
while found:
    if os.path.exists('dump.'+str(frame)+'.xtc'):
        frame_list.append('dump.'+str(frame)+'.xtc')
        frame += 1
    else:
        found = False


# In[5]:


# merge the frames
u = mda.Universe('../configuration.xyz', frame_list)
u.transfer_to_memory()
with mda.Writer('merged_frame.xtc', u.atoms.n_atoms) as W:
    for ts in u.trajectory:
        W.write(u)


# In[6]:


# delete single frames
for myframe in frame_list:
    try:
        os.remove(myframe)
    except:
        pass


# In[9]:


# delete single frames
for myframe in frame_list:
    try:
        os.remove('.'+myframe+'_offsets.lock')
    except:
        pass


# In[10]:


# delete single frames
for myframe in frame_list:
    try:
        os.remove('.'+myframe+'_offsets.npz')
    except:
        pass

