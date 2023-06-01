#!/bin/bash

set -e

for file in _untitled.*.ppm; 
do 
	convert $file -transparent white $file.png;
done

