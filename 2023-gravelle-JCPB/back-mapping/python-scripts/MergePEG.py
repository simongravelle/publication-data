#!/usr/bin/env python
# coding: utf-8

from shutil import rmtree
import MDAnalysis as mda
import numpy as np
import warnings
import os
warnings.filterwarnings('ignore')

# detect number of frames
frame = 1
frame_list = []
found = True
while found:
    if os.path.exists('dump.'+str(frame)+'.xtc'):
        frame_list.append('dump.'+str(frame)+'.xtc')
        frame += 1
    else:
        found = False
        
# merge the frames
u = mda.Universe('configuration.xyz', frame_list)
u.transfer_to_memory()
with mda.Writer('merged_frame.xtc', u.atoms.n_atoms) as W:
    for ts in u.trajectory:
        W.write(u)

# delete single frames (optional)
for myframe in frame_list:
    try:
        os.remove(myframe)
    except:
        pass

# delete single frames lock (optional)
for myframe in frame_list:
    try:
        os.remove('.'+myframe+'_offsets.lock')
    except:
        pass

# delete single frames npz (optional)
for myframe in frame_list:
    try:
        os.remove('.'+myframe+'_offsets.npz')
    except:
        pass

