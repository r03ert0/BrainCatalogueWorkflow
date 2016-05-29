#!/bin/bash

# combine-left-right-all, R. Toro 18 May 2016
# script based on all.sh, which called combine-left-right.sh
# all.sh now contains updated db arrays with different sets of animals, and
# an updated location for the files
# usage: source combine-left-right-all.sh 10


# combines annotations from left/right hemisphere into a single brain
# Example call:
# source combine-left-right.sh both.ply left.ply right.ply left.sratio.txt right.sratio.txt 10 > both.sratio.txt
# (to convert from curv format to text: meshgeometry -i mesh.sratio.curv -odata mesh.sratio.txt)
# mg=/Users/ghfc/Applications/brainbits/meshgeometry/meshgeometry_mac

# original
db1=( roberto baboon capuchin ce_macaque douroucouli mangabey galago orangutan gorilla slow_loris  )
r=$1 #radius of the sphere to measure surfaceratio, like 5, 10, 15, 20
mm=mm

src=/Users/ghfc/Documents/Dropbox/hugo_is_dead/scripts/BrainCatalogueWorkflow/meshes_centered

# process
for i in ${db1[@]}
do
    $mg -i $src/$i/surfaceratio/right_$r$mm.curv -odata $src/$i/surfaceratio/right.sratio_$r$mm.txt
    $mg -i $src/$i/surfaceratio/left_$r$mm.curv -odata $src/$i/surfaceratio/left.sratio_$r$mm.txt

    source combine-left-right.sh $src/$i/both.ply $src/$i/left.ply $src/$i/right.ply $src/$i/surfaceratio/left.sratio_$r$mm.txt $src/$i/surfaceratio/right.sratio_$r$mm.txt > $src/$i/surfaceratio/both.sratio_$r$mm.txt
done

