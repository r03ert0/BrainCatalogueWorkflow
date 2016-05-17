# combine-left-right, R. Toro 17 May 2016
# combines annotations from left/right hemisphere into a single brain
#
# Example call:
# source combine-left-right.sh both.ply left.ply right.ply left.sratio.txt right.sratio.txt > both.sratio.txt
#
# (to convert from curv format to text: meshgeometry -i mesh.sratio.curv -odata mesh.sratio.txt)

both=$1    # meshes_centered/baboon/both.ply
left=$2    # meshes_centered/baboon/left.ply
right=$3   # meshes_centered/baboon/right.ply
leftsr=$4  # meshes_centered/baboon/surfaceratio/left.sratio.txt
rightsr=$5 # meshes_centered/baboon/surfaceratio/right.sratio.txt

awk '\
  BEGIN{f=0;state=0}\
  (FNR==1){state+=1}\
  /element vertex/{np=$3;if(state==1)npboth=np;}\
  {  if(state==1) {\
       if(f) {arr[$1" "$2" "$3]=i;i++}\
       if(i==np) f=0;\
     }\
     if(state==2) {\
       if(f) {lut["L"i]=arr[$1" "$2" "$3];i++}\
       if(i==np) f=0;\
     }\
     if(state==3) {\
       if(f) {lut["R"i]=arr[$1" "$2" "$3];i++}\
       if(i==np) f=0;\
     }\
     if(state==4) if(FNR>1) sr[lut["L"(FNR-2)]]=$0;\
     if(state==5) if(FNR>1) sr[lut["R"(FNR-2)]]=$0;\
  }\
  /end_header/{f=1;i=0}\
  END{print npboth,1,1;for(i=0;i<npboth;i++)print sr[i]}\
' $both $left $right $leftsr $rightsr

