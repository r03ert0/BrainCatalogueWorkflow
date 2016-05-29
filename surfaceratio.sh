#!/bin/bash

#usage: source sourfaceratio.sh 20

# original
db1=( roberto gorilla baboon capuchin orangutan ce_macaque mangabey douroucouli  galago slow_loris )

src=/Users/ghfc/Documents/Dropbox/hugo_is_dead/scripts/BrainCatalogueWorkflow/meshes_centered

sr=/Users/ghfc/Documents/Dropbox/hugo_is_dead/scripts/surfaceratio/surfaceratio
mg=/Users/ghfc/Applications/brainbits/meshgeometry/meshgeometry_mac
r=$1 #radius of the sphere to calculate surfaceratio in mm, like 5, 10, 20
mm=mm #just to know that it's mm

# process
for i in ${db1[@]}
do

# 	mkdir $src/$i/surfaceratio

#    $mg -i $src/$i/left.ply -o $src/$i/surfaceratio/left.pial
#    $mg -i $src/$i/right.ply -o $src/$i/surfaceratio/right.pial #comment this out if surfaces are there already


    $sr $src/$i/surfaceratio/left.pial $src/$i/surfaceratio/left_$r$mm.curv $r
    $sr $src/$i/surfaceratio/right.pial $src/$i/surfaceratio/right_$r$mm.curv $r


done
