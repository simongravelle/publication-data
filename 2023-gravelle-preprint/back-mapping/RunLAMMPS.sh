#!/usr/bin/bash

set -e

# sleep a random time to avoid overlaping
#sleep .$[ ( $RANDOM % 10 ) + 1 ]s

while IFS="" read -r p || [ -n "$p" ] # loop on PEG index
do

  cpt_PEG=$((p + 1))

  if test -f 'dump/_PEG'$cpt_PEG'.temp'
  then
    true 
  else

    touch 'dump/_PEG'$cpt_PEG'.temp'

    for ns in {0..99} # loop on time
    do
      
      working_folder=$"dump/PEG$cpt_PEG/ns$ns"
      temporary_folder=$"dump/PEG$cpt_PEG/_ns$ns"
      final_file=$"dump/PEG$cpt_PEG/trj.$ns.xtc"
      if test -d $working_folder ; 
      then
        true
      else 
        if test -d $temporary_folder ; 
        then
          true
        else
          if test -f final_file ;
          then
            true
          else
            printf 'Dealing with %s\n' "$working_folder"

            # create dump folder
            mkdir -p $temporary_folder

            # go to temporary folder
            cd "tempPEG"$cpt_PEG

            # copy input file, and replace the lines
            cp ../inputs/input.follow.lammps .
            newline='read_data ../data/PEG.'$cpt_PEG'.data'
            linetoreplace=$(cat input.follow.lammps | grep 'read_data PEG.data')
            sed -i '/'"$linetoreplace"'/c\'"$newline" input.follow.lammps
            newline='write_data ../data/PEG.'$cpt_PEG'.data'
            linetoreplace=$(cat input.follow.lammps | grep 'write_data PEG.data')
            sed -i '/'"$linetoreplace"'/c\'"$newline" input.follow.lammps

            # read tether positions
            filex=../tether/PEG$cpt_PEG/ns$ns/TETHER.x.lammps
            filey=../tether/PEG$cpt_PEG/ns$ns/TETHER.y.lammps
            filez=../tether/PEG$cpt_PEG/ns$ns/TETHER.z.lammps
            readarray -t arrayx < $filex
            readarray -t arrayy < $filey
            readarray -t arrayz < $filez

            # loop on all positions
            for ii in "${!arrayx[@]}"
            do

              # extract tether positions 
              IFS=', ' read -r -a linex <<< "${arrayx[ii]}"
              IFS=', ' read -r -a liney <<< "${arrayy[ii]}"
              IFS=', ' read -r -a linez <<< "${arrayz[ii]}"
              x1=${linex[0]}
              x2=${linex[1]}
              x3=${linex[2]}
              x4=${linex[3]}
              x5=${linex[4]}
              y1=${liney[0]}
              y2=${liney[1]}
              y3=${liney[2]}
              y4=${liney[3]}
              y5=${liney[4]}
              z1=${linez[0]}
              z2=${linez[1]}
              z3=${linez[2]}
              z4=${linez[3]}
              z5=${linez[4]}

              # update spring tether positions
              newline='fix pull1 MON1 spring tether 10000 '$x1' '$y1' '$z1' 0'
              linetoreplace=$(cat input.follow.lammps | grep 'fix pull1 MON1 spring tether')
              sed -i '/'"$linetoreplace"'/c\'"$newline" input.follow.lammps
              newline='fix pull2 MON2 spring tether 10000 '$x2' '$y2' '$z2' 0'
              linetoreplace=$(cat input.follow.lammps | grep 'fix pull2 MON2 spring tether')
              sed -i '/'"$linetoreplace"'/c\'"$newline" input.follow.lammps
              newline='fix pull3 MON3 spring tether 10000 '$x3' '$y3' '$z3' 0'
              linetoreplace=$(cat input.follow.lammps | grep 'fix pull3 MON3 spring tether')
              sed -i '/'"$linetoreplace"'/c\'"$newline" input.follow.lammps
              newline='fix pull4 MON4 spring tether 10000 '$x4' '$y4' '$z4' 0'
              linetoreplace=$(cat input.follow.lammps | grep 'fix pull4 MON4 spring tether')
              sed -i '/'"$linetoreplace"'/c\'"$newline" input.follow.lammps
              newline='fix pull5 MON5 spring tether 10000 '$x5' '$y5' '$z5' 0'
              linetoreplace=$(cat input.follow.lammps | grep 'fix pull5 MON5 spring tether')
              sed -i '/'"$linetoreplace"'/c\'"$newline" input.follow.lammps

              {
                /home/simon/Softwares/lammps-28Mar2023/src/lmp_serial -in input.follow.lammps
              } &> /dev/null

              cp ../AssertLAMMPS.py .
              python3 AssertLAMMPS.py
      
              
              mv dump.xtc "../"$temporary_folder"/dump.${ii}.xtc"

            done

            cd ..
            
           
            # sleep a random time to avoid overlaping
            #sleep .$[ ( $RANDOM % 10 ) + 1 ]s

            # deal with the trajectory
            cd $temporary_folder
            
            cp ../../../MergePEG.py .
            python3 MergePEG.py
            cd ../../../

            # make the temporary folder definitive
            mv $temporary_folder $working_folder

            # sleep a random time to avoid overlaping
            #sleep .$[ ( $RANDOM % 10 ) + 1 ]s
            
          fi
        fi
      fi 
    done
    # delete the PEG file
    rm 'dump/_PEG'$cpt_PEG'.temp'
  fi
done < PEG.list
