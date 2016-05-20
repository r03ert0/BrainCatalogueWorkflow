#!/bin/bash


# original
db1=( roberto
#gorilla baboon capuchin ce_macaque douroucouli mangabey galago slow_loris orangutan
)

src=/Users/ghfc/Documents/Dropbox/hugo_is_dead/scripts/BrainCatalogueWorkflow/meshes_centered

sr=/Users/ghfc/Documents/Dropbox/hugo_is_dead/scripts/surfaceratio/surfaceratio
mg=/Users/ghfc/Applications/brainbits/meshgeometry/meshgeometry_mac

# process
for i in ${db1[@]}
do
	mkdir $src/$i
	mkdir $src/$i/surfaceratio

    $mg -i $src/$i/left.ply -o $src/$i/surfaceratio/left.pial
    $mg -i $src/$i/right.ply -o $src/$i/surfaceratio/right.pial

    $sr $src/$i/surfaceratio/left.pial $src/$i/surfaceratio/left.curv
    $sr $src/$i/surfaceratio/right.pial $src/$i/surfaceratio/right.curv
done
