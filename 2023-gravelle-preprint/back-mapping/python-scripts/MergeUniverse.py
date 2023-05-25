#!/usr/bin/env python
# coding: utf-8

# In[8]:


from MDAnalysis.coordinates.memory import MemoryReader
from MDAnalysis import transformations
from matplotlib import pyplot as plt 
from copy import deepcopy
from shutil import rmtree
import MDAnalysis as mda
import numpy as np
import os


# In[9]:


def add_names(uni):
    _name = []
    for _type in uni.atoms.types:
        if _type == '3':
            _name.append('C')
        elif (_type == '4') | (_type == '6'):
            _name.append('O')
        elif (_type == '5') | (_type == '7'):
            _name.append('H')
    uni.add_TopologyAttr('name', _name)
    return uni


# In[10]:


def import_universe(data, trj, _atom_per_peg, _PEG):
    uni = mda.Universe(data, trj)
    uni.transfer_to_memory()
    assert uni.atoms.n_atoms == _atom_per_peg
    uni = add_names(uni)
    uni.residues.resids = _PEG
    u_trj = np.zeros((uni.trajectory.n_frames, _atom_per_peg, 3))
    for ts in uni.trajectory:
        u_trj[ts.frame] = uni.atoms.positions
    return uni, u_trj


# In[11]:


dimensions = np.loadtxt("dimensions.dat")
atom_per_peg = 31


# In[12]:


# detect number of PEG
PEG = 1
PEG_list = []
found = True
while found:
    if os.path.exists('PEG'+str(PEG)+'/configuration.xyz'):
        PEG_list.append(PEG)
        PEG += 1
    else:
        found = False
print("number of PEGs:", len(PEG_list))


# In[13]:


# Assert that trajectory is complete
for PEG in PEG_list: 
    for ns in range(100):
        xtc = 'PEG'+str(PEG)+'/ns'+str(ns)+'/merged_frame.xtc'
        assert os.path.exists(xtc), """Missing trj file """ + str(PEG) + """ """ + str(ns)
        assert os.path.getsize(xtc) > 500, """xtc file too small."""


# In[14]:


# merge PEG together
packed = []
for ns in range(100):
    all_xtc = []
    for PEG in PEG_list: 
        xtc = 'PEG'+str(PEG)+'/ns'+str(ns)+'/merged_frame.xtc'
        all_xtc.append(xtc)
    for PEG, trj in zip(PEG_list, all_xtc):   
        data = "../data/PEG."+str(PEG)+"_0.data"
        if PEG == 1:
            u, u_trj = import_universe(data, trj, atom_per_peg, PEG)
        else:
            v, v_trj = import_universe(data, trj, atom_per_peg, PEG)
            assert u.trajectory.n_frames == v.trajectory.n_frames
            u = mda.Merge(u.select_atoms("all"), v.select_atoms("all"))
            u_trj = np.concatenate((u_trj, v_trj), axis=1)
            u.load_new(u_trj, format=MemoryReader)
            assert u.trajectory.n_frames == v.trajectory.n_frames
            #print(v.trajectory.n_frames)
            #assert v.trajectory.n_frames == 250
            assert u.atoms.n_atoms == atom_per_peg*PEG
    # print configuration
    if ns == 1:
        u.dimensions = [dimensions[0], dimensions[1], dimensions[2], 90, 90, 90]
        u.select_atoms('all').write("configuration.pdb")
    with mda.Writer("merged"+str(ns)+".xtc", u.atoms.n_atoms) as W:
        for ts in u.trajectory:
            ts.dimensions = [dimensions[0], dimensions[1], dimensions[2], 90, 90, 90]
            W.write(u)
    packed.append("merged"+str(ns)+".xtc")


# In[ ]:


# write the final trajectory
w = mda.Universe("configuration.pdb", packed)
H = w.select_atoms("name H")


# In[ ]:


# verify trj
max_diff = []
mean_diff = []
for ts in w.trajectory:
    positions1 = H.positions
    if ts.frame > 0:
        diff = positions0 - positions1
        max_diff.append(np.max(np.abs(diff)))
        mean_diff.append(np.mean(np.abs(diff)))
    positions0 = deepcopy(positions1)
print("Large jump ", np.sum(np.array(mean_diff) > 1))
#assert np.max(max_diff) < 4, """TOO MANY DANGEROUS JUMP"""
        


# In[ ]:


# wrap it
ag = w.atoms
transform = mda.transformations.wrap(ag)
w.trajectory.add_transformations(transform)
with mda.Writer("full_merged.xtc", w.atoms.n_atoms) as W:
    for ts in w.trajectory:
        ts.dimensions = [dimensions[0], dimensions[1], dimensions[2], 90, 90, 90]
        W.write(w)


# In[ ]:


# errase all
#for PEG in PEG_list:
#    #for ns in range(100):
#    folder = "PEG"+str(PEG)
#    try:
#        rmtree(folder)
#    except:
#        print("FOLDER NOT DELETABLE")
for ns in range(100):
    file = "merged"+str(ns)+".xtc"
    try:
        os.remove(file)
    except:
        print("FILE NOT DELETABLE")
for ns in range(100):
    file = ".merged"+str(ns)+".xtc_offsets.npz"
    try:
        os.remove(file)
    except:
        print("FILE NOT DELETABLE")


# ## rewrap

# In[ ]:


w = mda.Universe("configuration.pdb", "full_merged.xtc")
H = w.select_atoms("name H")
# wrap it
ag = w.atoms
transform = mda.transformations.wrap(ag)
w.trajectory.add_transformations(transform)
with mda.Writer("full_merged_bis.xtc", w.atoms.n_atoms) as W:
    for ts in w.trajectory:
        ts.dimensions = [dimensions[0], dimensions[1], dimensions[2], 90, 90, 90]
        W.write(w)

