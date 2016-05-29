#!/bin/bash
# v12

plymesh=$1
fsmesh=$2

# meshparam converts a mesh (euler=2) into a sphere
# meshparam=/Users/roberto/Applications/brainbits/m.meshparam/build/Debug/meshparam
meshparam=/Users/ghfc/Applications/brainbits/meshparam/meshparam

# meshgreometry can do a lot of different operations on meshes
# meshgeometry=/Users/roberto/Applications/brainbits/m.meshgeometry/meshgeometry_mac
meshgeometry=/Users/ghfc/Applications/brainbits/meshgeometry/meshgeometry_mac

echo START
date

echo "subdivide "$plymesh", and save as freesurfer"
#  -v                                                              be verbose about what you do
#  -i $plymesh.ply                                                 input mesh
#  -subdivide                                                      subdivide the input mesh (add vertices to make it smooth)
#  -centre                                                         displace the mesh to it's centre
#  -o $fsmesh.white                                                write the result and use it as freesurfer's "white matter" segmentation
#  -depth -o $fsmesh.depth.curv                                    compute the sulcal depth, use it as FS's "sulcal depth" data file
#  -laplaceSmooth 0.5 2 -curv -o $fsmesh.curv                      Laplace smooth the mesh, compute the curvature, use it as "mean curvature" file
#  -icurv 20                  -o $fsmesh.sulc -o $fsmesh.inflated  apply integrated smoothing, use the result as "sulc" file
#  -curv                      -o $fsmesh.inflated.curv             icurv smoothes the mesh, use this mesh as FS's inflated mesh
$meshgeometry	-v \
				-i $plymesh.ply \
				-subdivide \
				-centre \
				-o $fsmesh.white \
				-depth					   -o $fsmesh.depth.curv \
				-laplaceSmooth 0.5 2 -curv -o $fsmesh.curv \
				-icurv 20                  -o $fsmesh.sulc -o $fsmesh.inflated \
				-curv                      -o $fsmesh.inflated.curv
echo "rename inflated.curv to inflated.H"
mv $fsmesh.inflated.curv $fsmesh.inflated.H

#echo "convert "$plymesh" to sphere"
#$meshparam -i ${plymesh}.ply -o ${plymesh}.sphere.ply #to use Julien's spheres: safe the spheres generated in matlab first and comment this out

echo "make the distribution of vertices over the sphere uniform, then align, subdivide and save as freesurfer"
$meshgeometry	-v \
				-i ${plymesh}.sphere.ply \
				-uniform \
				-align ${plymesh}.ply \
				-subdivide \
				-centre \
				-o $fsmesh.sphere
date
echo END