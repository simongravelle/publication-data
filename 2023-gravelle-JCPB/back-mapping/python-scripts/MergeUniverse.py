#!/usr/bin/env python
# coding: utf-8

from MDAnalysis.coordinates.memory import MemoryReader
from MDAnalysis import transformations
from copy import deepcopy
from shutil import rmtree
import MDAnalysis as mda
import numpy as np
import os

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

def import_universe(data, trj, atom_per_peg, PEG):
    uni = mda.Universe(data, trj)
    uni.transfer_to_memory()
    assert uni.atoms.n_atoms == atom_per_peg
    uni = add_names(uni)
    uni.residues.resids = PEG
    u_trj = np.zeros((uni.trajectory.n_frames, atom_per_peg, 3))
    for ts in uni.trajectory:
        u_trj[ts.frame] = uni.atoms.positions
    return uni, u_trj

dimensions = np.loadtxt("dimensions.dat")
atom_per_peg = 31 # hadr coded

# detect number of PEG
PEG = 1
PEG_list = []
all_xtc = []
found = True
while found:
    if os.path.exists('PEG'+str(PEG)+'/configuration.xyz'):
        PEG_list.append(PEG)
        all_xtc.append('PEG'+str(PEG)+'/merged_frame.xtc')
        PEG += 1
    else:
        found = False
print("number of PEG molecules:", len(PEG_list))

# merge all PEG together into a single universe
for PEG, trj in zip(PEG_list, all_xtc):   
    data = "../_lammps-data/PEG."+str(PEG)+".data"
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

# give proper dimensions to the universe
u.dimensions = [dimensions[0], dimensions[1], dimensions[2], 90, 90, 90]
u.select_atoms('all').write("configuration.pdb")

with mda.Writer("unwrapped_merged.xtc", u.atoms.n_atoms) as W:
    for ts in u.trajectory:
        ts.dimensions = [dimensions[0], dimensions[1], dimensions[2], 90, 90, 90]
        W.write(u)

# wrap the universe (optional)
w = mda.Universe("configuration.pdb", "unwrapped_merged.xtc")
ag = w.atoms
transform = mda.transformations.wrap(ag)
w.trajectory.add_transformations(transform)
with mda.Writer("wrapped_merged.xtc", w.atoms.n_atoms) as W:
    for ts in w.trajectory:
        ts.dimensions = [dimensions[0], dimensions[1], dimensions[2], 90, 90, 90]
        W.write(w)
