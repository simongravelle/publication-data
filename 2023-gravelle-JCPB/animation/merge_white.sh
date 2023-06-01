#!/bin/bash
# Credit to Otello M Roscioni from Bristol who kindly share his script : https://matsci.org/u/hothello

export LC_NUMERIC="en_US.UTF-8"

set -e

format=480x284 # 960x568 1920x1136

# resize and add transparent backgroung
# AA
for file in _AA-white/_untitled.*.ppm; 
do
    convert $file -resize $format ${file:0:25}.png; # -transparent black 
done
# CG
for file in _CG-white/_untitled.*.ppm; 
do
    convert $file -resize $format ${file:0:25}.png; # -transparent white
done

for i in {0..199}; 
do
    # x1 = start of the gradient
    x1=$(printf "%.0f" $(bc -l<<<\($i+1\)*3))
    # x2 = end of the gradient
    x2=$(printf "%.0f" $(bc -l<<<\($i+1\)*4))
    j=$(printf "%05i" $(bc -l<<<$i))
    # create a linear gradient file
    convert -size $format -define gradient:vector=$x1,500,$x2,500,angle=90 gradient:white-black _linear_gradient.png
	# compose the 2 images
    convert _CG-white/_untitled.$j.png _linear_gradient.png -alpha remove -compose CopyOpacity -composite _AA-white/_untitled.$j.png -compose DstOver -composite _base_out.png
    convert -alpha remove _base_out.png _Merged-white/_untitled.$j.png
done

rm _linear_gradient.png _base_out.png
# q is compression factor, default 75, d is the duration
img2webp -o CG-AA-white.webp  -q 45 -d 66.66 _Merged-white/*.png # -q 100 -mixed