#!/usr/bin/bash

set -e

# path to lammps
lmp=/home/simon/Softwares/lammps-8Feb2023/src/lmp_serial 

# Extract the positions of the bead, and create list of positions
# Those lists will later be used in LAMMPS
cp python-scripts/GenerateTether.py .
python3 GenerateTether.py
rm -f GenerateTether.py

while IFS="" read -r p || [ -n "$p" ]
do

    cpt_PEG=$((p + 1))

    # create the trajectory frame by frame
    WORKING_DIR="_PEG"$cpt_PEG
    mkdir -p ${WORKING_DIR}
    cd ${WORKING_DIR}
        printf 'Dealing with PEG%s\n' "$cpt_PEG"

        # copy data file, and replace the lines
        cp ../PEG-parameters/PEG.data ../_lammps-data/PEG.$cpt_PEG.data

        # copy input file
        cp ../lammps-inputs/input.lammps input.PEG$cpt_PEG.lammps

        # update cpt_PEG
        newline='variable cpt_PEG equal '$cpt_PEG
        linetoreplace=$(cat input.PEG$cpt_PEG.lammps | grep 'variable cpt_PEG equal')
        sed -i '/'"$linetoreplace"'/c\'"$newline" input.PEG$cpt_PEG.lammps

        # read tether positions and extract the 5 tether positions 
        readarray -t arrayx < ../_tether_positions/PEG$cpt_PEG/TETHER.x.lammps
        readarray -t arrayy < ../_tether_positions/PEG$cpt_PEG/TETHER.y.lammps
        readarray -t arrayz < ../_tether_positions/PEG$cpt_PEG/TETHER.z.lammps

        # loop on all positions
        for ii in "${!arrayx[@]}"
        do
            
            # update cpt_PEG
            newline='variable cpt_dump equal '$ii
            linetoreplace=$(cat input.PEG$cpt_PEG.lammps | grep 'variable cpt_dump equal')
            sed -i '/'"$linetoreplace"'/c\'"$newline" input.PEG$cpt_PEG.lammps

            IFS=', ' read -r -a linex <<< "${arrayx[ii]}"
            x1=${linex[0]}
            x2=${linex[1]}
            x3=${linex[2]}
            x4=${linex[3]}
            x5=${linex[4]}

            IFS=', ' read -r -a liney <<< "${arrayy[ii]}"
            y1=${liney[0]}
            y2=${liney[1]}
            y3=${liney[2]}
            y4=${liney[3]}
            y5=${liney[4]}

            IFS=', ' read -r -a linez <<< "${arrayz[ii]}"
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

            if [ "$ii" -eq "0" ];
            then
                newline='variable equilibrate equal 1'
            else
                newline='variable equilibrate equal 0'
            fi
            linetoreplace=$(cat input.PEG$cpt_PEG.lammps | grep 'variable equilibrate equal')
            sed -i '/'"$linetoreplace"'/c\'"$newline" input.PEG$cpt_PEG.lammps

            # run lammps
            {
                ${lmp} -in input.PEG$cpt_PEG.lammps
            } &> /dev/null

        done
    cd ..
    rm -rf ${WORKING_DIR}

    # merge the trajectory into a single xtc file
    DUMP_DIR="_lammps-dump/PEG"$cpt_PEG
    cd $DUMP_DIR
        cp ../../python-scripts/MergePEG.py .
        python3 MergePEG.py
    cd ../../

done < _PEG.list

cd _lammps-dump
  cp ../python-scripts/MergeUniverse.py  .
  python3 MergeUniverse.py
  rm -f MergeUniverse.py
cd ..






