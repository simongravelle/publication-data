#!/usr/bin/env python
# coding: utf-8

# In[23]:


import MDAnalysis as mda
import numpy as np
import os
import gc

def make_tether(u, PEG, cpt_res):
    allx, ally, allz = [], [], []
    for _ in u.trajectory:
        allx.append(PEG.atoms.positions.T[0])
        ally.append(PEG.atoms.positions.T[1])
        allz.append(PEG.atoms.positions.T[2])
    f1 = open('tether/PEG'+str(cpt_res+1)+'/TETHER.x.lammps', 'w')
    f2 = open('tether/PEG'+str(cpt_res+1)+'/TETHER.y.lammps', 'w')
    f3 = open('tether/PEG'+str(cpt_res+1)+'/TETHER.z.lammps', 'w')
    for x, y, z in zip(allx, ally, allz):
        f1.write(str(np.round(x[0],2))+' '+str(np.round(x[1],2))+' '+str(np.round(x[2],2))+' '+str(np.round(x[3],2))+' '+str(np.round(x[4],2))+'\n')
        f2.write(str(np.round(y[0],2))+' '+str(np.round(y[1],2))+' '+str(np.round(y[2],2))+' '+str(np.round(y[3],2))+' '+str(np.round(y[4],2))+'\n')
        f3.write(str(np.round(z[0],2))+' '+str(np.round(z[1],2))+' '+str(np.round(z[2],2))+' '+str(np.round(z[3],2))+' '+str(np.round(z[4],2))+'\n')
    f1.close()
    f2.close()
    f3.close()

if not os.path.exists('dump/'):
    os.mkdir('dump')
if not os.path.exists('data/'):
    os.mkdir('data')

# original CG trajectory
gro = "C-CG/conf.gro"
trj = "C-CG/traj.trr"

original_univers = mda.Universe(gro, trj)
dimensions = original_univers.dimensions
n_frames = original_univers.trajectory.n_frames
timestep = np.round(original_univers.trajectory.dt,2)

# save and import dimensions, not sure why
f = open("dump/dimensions.dat", "w")
f.write(str(dimensions[0])+' '+str(dimensions[1])+' '+str(dimensions[2])+' '+str(dimensions[3])+' '+str(dimensions[4])+' '+str(dimensions[5])+'\n')
f.close()
dimensions = np.loadtxt("dump/dimensions.dat")

# detect the peg list from the CG trajecotry
PEG_list = []
for cpt_res, ids in enumerate(original_univers.residues.ids):
    PEG_list.append(cpt_res)
f = open('PEG.list', 'w')
for x in PEG_list:
    f.write(str(x)+'\n')
f.close()

if not os.path.exists('tether/'):
    os.mkdir('tether')
for cpt_PEG in PEG_list:
    if not os.path.exists('dump/PEG'+str(cpt_res+1)):
        os.mkdir('dump/PEG'+str(cpt_res+1))
    if not os.path.exists('tether/PEG'+str(cpt_PEG+1)):
        os.mkdir('tether/PEG'+str(cpt_PEG+1))
    u = mda.Universe(gro, trj)
    PEG = u.select_atoms('resindex '+str(cpt_PEG)) # select the cpt_PEG PEG molecule
    make_tether(u, PEG, cpt_PEG)

