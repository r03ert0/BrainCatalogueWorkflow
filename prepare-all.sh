#!/bin/bash

# 20 August 2015, Roberto Toro
# script based on all.sh, which called prepare4sd.sh
# all.sh now contains updated db arrays with different sets of animals, and
# an updated location for the files

# original
db1=( baboon ce_macaque 
#douroucouli roberto capuchin mangabey galago slow_loris orangutan gorilla
)

src=/Users/ghfc/Documents/Dropbox/hugo_is_dead/scripts/BrainCatalogueWorkflow/meshes_centered
dst=/Users/ghfc/Documents/Dropbox/hugo_is_dead/scripts/BrainCatalogueWorkflow/results

meshgeometry=/Users/ghfc/Applications/brainbits/meshgeometry/meshgeometry_mac

# process
for i in ${db1[@]}
do
#	mkdir $dst/$i
#	mkdir $dst/$i/surf
	source prepare.sh $src/$i/both $dst/$i/surf/rh
done
