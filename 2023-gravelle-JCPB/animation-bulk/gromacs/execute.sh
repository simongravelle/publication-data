#!/bin/sh

gmx grompp -f input/input.mdp -o run -pp run -po run -maxwarn 1
gmx mdrun -v -deffnm run -nt 4

# gmx trjconv -s run.tpr -f run.xtc -o AA.xtc -pbc nojump

