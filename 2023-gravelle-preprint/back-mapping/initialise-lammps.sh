#!/usr/bin/bash

set -e

# path to lammps
lmp=/home/simon/Softwares/lammps-8Feb2023/src/lmp_serial 

# Extract the positions of the bead, and create list of positions
# Those list will later be used in LAMMPS
cp python-scripts/GenerateTether.py .
python3 GenerateTether.py
rm GenerateTether.py

while IFS="" read -r p || [ -n "$p" ]
do

    cpt_PEG=$((p + 1))

    WORKING_DIR="_PEG"$cpt_PEG

    mkdir -p ${WORKING_DIR}
    #cp _PEG.list ${WORKING_DIR}
    cd ${WORKING_DIR}

        printf 'Dealing with PEG%s\n' "$cpt_PEG"

        # copy data file, and replace the lines
        cp ../PEG-parameters/PEG.data ../_lammps-data/PEG.$cpt_PEG.data

        # copy input file, and replace the lines
        cp ../lammps-inputs/input.prepare.lammps input.PEG$cpt_PEG.lammps

        newline='read_data ../_lammps-data/PEG.'$cpt_PEG'.data'
        linetoreplace=$(cat input.PEG$cpt_PEG.lammps | grep 'read_data PEG.data')
        sed -i '/'"$linetoreplace"'/c\'"$newline" input.PEG$cpt_PEG.lammps

        newline='write_data ../_lammps-data/PEG.'$cpt_PEG'.data'
        linetoreplace=$(cat input.PEG$cpt_PEG.lammps | grep 'write_data PEG.data')
        sed -i '/'"$linetoreplace"'/c\'"$newline" input.PEG$cpt_PEG.lammps

        newline='write_dump all atom ../_lammps-dump/PEG'$cpt_PEG'/configuration.lammpstrj'
        linetoreplace=$(cat input.PEG$cpt_PEG.lammps | grep 'write_dump all atom')
        sed -i '/'"$linetoreplace"'/c\'"$newline" input.PEG$cpt_PEG.lammps

        newline='write_dump all xyz ../_lammps-dump/PEG'$cpt_PEG'/configuration.xyz'
        linetoreplace=$(cat input.PEG$cpt_PEG.lammps | grep 'write_dump all xyz')
        sed -i '/'"$linetoreplace"'/c\'"$newline" input.PEG$cpt_PEG.lammps

        # read tether positions and extract the 5 tether positions 
        readarray -t arrayx < ../_tether_positions/PEG$cpt_PEG/TETHER.x.lammps
        readarray -t arrayy < ../_tether_positions/PEG$cpt_PEG/TETHER.y.lammps
        readarray -t arrayz < ../_tether_positions/PEG$cpt_PEG/TETHER.z.lammps

        IFS=', ' read -r -a linex <<< "${arrayx[i]}"
        x1=${linex[0]}
        x2=${linex[1]}
        x3=${linex[2]}
        x4=${linex[3]}
        x5=${linex[4]}

        IFS=', ' read -r -a liney <<< "${arrayy[i]}"
        y1=${liney[0]}
        y2=${liney[1]}
        y3=${liney[2]}
        y4=${liney[3]}
        y5=${liney[4]}

        IFS=', ' read -r -a linez <<< "${arrayz[i]}"
        z1=${linez[0]}
        z2=${linez[1]}
        z3=${linez[2]}
        z4=${linez[3]}
        z5=${linez[4]}

        # update spring tether positions
        newline='fix pull1 MON1 spring tether 10000 '$x1' '$y1' '$z1' 0'
        linetoreplace=$(cat input.PEG$cpt_PEG.lammps | grep 'fix pull1 MON1 spring tether')
        sed -i '/'"$linetoreplace"'/c\'"$newline" input.PEG$cpt_PEG.lammps
        newline='fix pull2 MON2 spring tether 10000 '$x2' '$y2' '$z2' 0'
        linetoreplace=$(cat input.PEG$cpt_PEG.lammps | grep 'fix pull2 MON2 spring tether')
        sed -i '/'"$linetoreplace"'/c\'"$newline" input.PEG$cpt_PEG.lammps
        newline='fix pull3 MON3 spring tether 10000 '$x3' '$y3' '$z3' 0'
        linetoreplace=$(cat input.PEG$cpt_PEG.lammps | grep 'fix pull3 MON3 spring tether')
        sed -i '/'"$linetoreplace"'/c\'"$newline" input.PEG$cpt_PEG.lammps
        newline='fix pull4 MON4 spring tether 10000 '$x4' '$y4' '$z4' 0'
        linetoreplace=$(cat input.PEG$cpt_PEG.lammps | grep 'fix pull4 MON4 spring tether')
        sed -i '/'"$linetoreplace"'/c\'"$newline" input.PEG$cpt_PEG.lammps
        newline='fix pull5 MON5 spring tether 10000 '$x5' '$y5' '$z5' 0'
        linetoreplace=$(cat input.PEG$cpt_PEG.lammps | grep 'fix pull5 MON5 spring tether')
        sed -i '/'"$linetoreplace"'/c\'"$newline" input.PEG$cpt_PEG.lammps

        # run lammps
        {
            ${lmp} -in input.PEG$cpt_PEG.lammps
        } &> /dev/null

        # ensure that the LAMMPS simulation ran without error
        cp ../python-scripts/AssertLAMMPS.py .
        python3 AssertLAMMPS.py
        rm AssertLAMMPS.py

    cd ..

    #cp 'data/PEG.'$cpt_PEG'.data'  'data/PEG.'$cpt_PEG'_init.data'

    # rm -r "tempPEG"$cpt_PEG
done < _PEG.list


#bash RunLAMMPS.sh &

# delete temp folder

#while IFS="" read -r p || [ -n "$p" ]
#do
#  cpt_PEG=$((p + 1))
#  DIR="tempPEG"$cpt_PEG
#  if [ -d "$DIR" ]; then
#    rm -rf "$DIR"
#  fi
#done < PEG.list

#cd dump
#  cp ../MergeUniverse.py .
#  python3 MergeUniverse.py
#cd ..






