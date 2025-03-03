# LAMMPS parameter file 
# Simon Gravelle

mass 1 12.011 # C18 - GROMOS
mass 2 1.008 # C18 - GROMOS
mass 3 12.011 # C18 - GROMOS
mass 4 15.9994 # H2O TIP4P
mass 5 1.008 # H2O TIP4P
mass 6 15.9994 # hydroxyl 10.1063/1.4942771
mass 7 1.008 # hydroxyl 10.1063/1.4942771
mass 8 15.9994 # hydronium 10.1063/1.4942771
mass 9 1.008 # hydronium 10.1063/1.4942771
mass 10 15.9994 # bicarbonate CHO3 - GROMOS
mass 11 15.9994 # bicarbonate CHO3 - GROMOS
mass 12 1.008 # bicarbonate CHO3 - GROMOS
mass 13 12.011 # bicarbonate CHO3 - GROMOS

pair_coeff 1 1 0.06630155 3.5811794 # C18 - GROMOS
pair_coeff 2 2 0.028293679 2.373408 # C18 - GROMOS
pair_coeff 3 3 0.06630155 3.5811794 # C18 - GROMOS
pair_coeff 4 4 0.1852 3.1589 # H2O TIP4P/2005
pair_coeff 5 5 0.0 1.0 # H2O TIP4P/2005
pair_coeff 6 6 0.01195 3.81  # hydroxyl 10.1063/1.4942771
pair_coeff 7 7 0.0 1.0 # hydroxyl 10.1063/1.4942771
pair_coeff 8 8 0.1912 3.1  # hydronium 10.1063/1.4942771
pair_coeff 9 9 0.0 1.0 # hydronium 10.1063/1.4942771
pair_coeff 10 10 0.41229546 2.625854 # bicarbonate CHO3 - GROMOS
pair_coeff 11 11 0.20306103 2.9548419 # bicarbonate CHO3 - GROMOS
pair_coeff 12 12 0.0 0.0 # bicarbonate CHO3 - GROMOS
pair_coeff 13 13 0.24501823 2.8114421 # bicarbonate CHO3 - GROMOS

bond_coeff 1 1109.2926 1.12 # C18 - GROMOS
bond_coeff 2 299.84396 1.52 # C18 - GROMOS
bond_coeff 3 203.15488 1.51 # C18 - GROMOS
bond_coeff 4 0.0 0.9574 # H2O TIP4P
bond_coeff 5 442.1606 0.972 # hydroxyl GROMOS
bond_coeff 6 478.01147 0.984 # hydronium GROMOS
bond_coeff 7 500.41827 1.25 # bicarbonate CHO3 - GROMOS
bond_coeff 8 399.79163 1.43 # bicarbonate CHO3 - GROMOS
bond_coeff 9 442.1606 0.972 # bicarbonate CHO3 - GROMOS

angle_coeff 1 30.173132 109.5 # C18 - GROMOS
angle_coeff 2 47.634956 109.6 # C18 - GROMOS
angle_coeff 3 55.113907 111.0 # C18 - GROMOS
angle_coeff 4 47.501896 108.53 # C18 - GROMOS
angle_coeff 5 54.993103 110.3 # C18 - GROMOS
angle_coeff 6 180.46019 109.0 # C18 - GROMOS
angle_coeff 7 298.15164 107.0 # C18 - GROMOS
angle_coeff 8 0.0 104.52 # H2O TIP4P
angle_coeff 9 47.69405 109.5  # hydronium GROMOS
angle_coeff 10 47.69405 109.5 # bicarbonate CHO3 - GROMOS
angle_coeff 11 60.165993 126.0 # bicarbonate CHO3 - GROMOS
angle_coeff 12 286.38248 113.0 # bicarbonate CHO3 - GROMOS

dihedral_coeff 1 1.414914 1 3 # C18 - GROMOS
dihedral_coeff 2 0.0 1 1 # C18 - GROMOS
dihedral_coeff 3 1.6993308 -1 2 # bicarbonate CHO3 - GROMOS
dihedral_coeff 4 0.0 1 1 # bicarbonate CHO3 - GROMOS

improper_coeff 1 20.007544 0.0 
