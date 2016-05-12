#!/bin/bash
# v12

txtmesh=$1
fsmesh=$2

# meshparam converts a mesh (euler=2) into a sphere
meshparam=/Users/roberto/Applications/brainbits/m.meshparam/build/Debug/meshparam

# stripmesh extracts vertices and triangles from a mesh
stripmesh=/Users/roberto/Applications/brainbits/m.stripmesh/stripmesh

# meshgreometry can do a lot of different operations on meshes
meshgeometry=/Users/roberto/Applications/brainbits/m.meshgeometry/meshgeometry_mac

echo START
date

echo "subdivide "$txtmesh", and save as freesurfer"
#  -v                                                              be verbose about what you do
#  -i $txtmesh.txt                                                 input mesh
#  -subdivide                                                      subdivide the input mesh (add vertices to make it smooth)
#  -centre                                                         displace the mesh to it's centre
#  -o $fsmesh.white                                                write the result and use it as freesurfer's "white matter" segmentation
#  -depth -o $fsmesh.depth.curv                                    compute the sulcal depth, use it as FS's "sulcal depth" data file
#  -laplaceSmooth 0.5 2 -curv -o $fsmesh.curv                      Laplace smooth the mesh, compute the curvature, use it as "mean curvature" file
#  -icurv 20                  -o $fsmesh.sulc -o $fsmesh.inflated  apply integrated smoothing, use the result as "sulc" file
#  -curv                      -o $fsmesh.inflated.curv             icurv smoothes the mesh, use this mesh as FS's inflated mesh
$meshgeometry	-v \
				-i $txtmesh.txt \
				-subdivide \
				-centre \
				-o $fsmesh.white \
				-depth					   -o $fsmesh.depth.curv \
				-laplaceSmooth 0.5 2 -curv -o $fsmesh.curv \
				-icurv 20                  -o $fsmesh.sulc -o $fsmesh.inflated \
				-curv                      -o $fsmesh.inflated.curv
echo "rename inflated.curv to inflated.H"
mv $fsmesh.inflated.curv $fsmesh.inflated.H

echo "convert "$txtmesh" to sphere"
$meshparam -i ${txtmesh}.txt -o ${txtmesh}.sphere.ply

echo "make the distribution of vertices over the sphere uniform, then align, subdivide and save as freesurfer"
$meshgeometry	-v \
				-i ${txtmesh}.sphere.ply \
				-uniform \
				-align ${txtmesh}.txt \
				-subdivide \
				-centre \
				-o $fsmesh.sphere
date
echo END