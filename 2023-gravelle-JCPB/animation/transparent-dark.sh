#!/bin/bash

set -e

for file in _untitled.*.ppm; 
do 
	convert $file -transparent black $file.png;
done

