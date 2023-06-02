# How to

![](CG-AA-white.webp)

1 - Run the LAMMPS input file *input.lammps* to generate the all-atom trajectory.

2 - Execute the *create_CoM.py* python script to convert the all-atom trajectory into a coarse-grained representation based on the center of mass of the atoms. 

3 - Generate images of both simulations using either VMD or ovito, and place the images in folder named *_AA-white* (or *_AA-dark*) and *_CG-white* (or *_CG-dark*), respectively.

4 - Run the bash script *merge_white.sh* (or *merge_dark.sh*)

