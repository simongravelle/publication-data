#!/bin/bash
# Credit to Otello M Roscioni from Bristol : https://matsci.org/u/hothello

export LC_NUMERIC="en_US.UTF-8"

set -e

cd AA-white
	cp ../transparent-white.sh .
	bash transparent-white.sh
	rm transparent-white.sh
cd ..
cd CG-white
	cp ../transparent-white.sh .
	bash transparent-white.sh
	rm transparent-white.sh
cd ..

for i in {0..199}; 
do

    x1=$(printf "%.0f" $(bc -l<<<\($i+1\)*2.083333))
    x2=$(printf "%.0f" $(bc -l<<<\($i+	1\)*5.2083333))

    j=$(printf "%05i" $(bc -l<<<$i))

    # create a linear gradient file
    convert -size 1920x1136 -define gradient:vector=$x1,500,$x2,500,angle=90 gradient:black-white _linear_gradient.png

    convert CG-white/_untitled.$j.ppm.png _linear_gradient.png -alpha remove -compose CopyOpacity -composite AA-white/_untitled.$j.ppm.png -compose DstOver -composite _base_out.png
    convert -alpha remove _base_out.png Merged/_untitled.$j.png

	rm _linear_gradient.png _base_out.png
done

cd Merged
	img2webp -o CG-AA-white.webp -q 40 -mixed -d 66.66 *.png
cd ..
