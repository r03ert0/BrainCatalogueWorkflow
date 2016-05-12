#!/bin/bash

# 20 August 2015, Roberto Toro
# script based on all.sh, which called prepare4sd.sh
# all.sh now contains updated db arrays with different sets of animals, and
# an updated location for the files

# original
db1=( Adult-F01 Adult-F03 Adult-F04 )

src= "SOURCE DIRECTORY (WHERE DATA IS TO BE FOUND)"
dst= "DESTINATION DIRECTORY (WHERE RESULTS WILL BE FOUND)"

meshgeometry=/path/to/meshgeometry_mac

# process
for i in ${db1[@]}
do
	mkdir $dst/$i
	mkdir $dst/$i/surf
	source prepare.sh $src/$i/rec-pial-e2/e2 $dst/$i/surf/rh
	
	source prepare.sh $dst/${i}m/surf/e2m $dst/${i}m/surf/rh
done
