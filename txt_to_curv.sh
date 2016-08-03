#!/bin/bash


# original
db1=( roberto gorilla baboon capuchin orangutan ce_macaque mangabey douroucouli  galago slow_loris )

src=/Users/ghfc/Documents/Dropbox/hugo_is_dead/scripts/BrainCatalogueWorkflow/meshes_centered
mg=/Users/ghfc/Applications/brainbits/meshgeometry/meshgeometry_mac

# process
for i in ${db1[@]}
do

    $mg -i $src/$i/surfaceratio/both.sratio_5mm.txt -o $src/$i/surfaceratio/both.sratio_5mm.curv
    $mg -i $src/$i/surfaceratio/both.sratio_10mm.txt -o $src/$i/surfaceratio/both.sratio_10mm.curv
    $mg -i $src/$i/surfaceratio/both.sratio_15mm.txt -o $src/$i/surfaceratio/both.sratio_15mm.curv
    $mg -i $src/$i/surfaceratio/both.sratio_20mm.txt -o $src/$i/surfaceratio/both.sratio_20mm.curv



done
