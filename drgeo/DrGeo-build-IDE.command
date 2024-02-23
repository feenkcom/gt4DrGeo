#! /bin/sh -x
#
# Install Dr. Geo in a Cuis-Smalltalk developer environment.
#
# Adapted from GH README
#
# Main page: https://www.gnu.org/software/dr-geo/
# GH repo: https://github.com/hilaire/drgeo
# 
# There is no Mac DrGeo download.
# This script has been adapted from the GH instructions to work on a Mac.

D=`dirname "$0"`
cd "$D"
echo `pwd`

# Install Cuis

cuisVersion=Cuis6-2

mkdir Cuis
cd Cuis
echo `pwd`

git clone https://github.com/Cuis-Smalltalk/$cuisVersion
git clone --depth 1 https://github.com/Cuis-Smalltalk/Cuis-Smalltalk-UI
git clone --depth 1 https://github.com/Cuis-Smalltalk/Erudite
git clone --depth 1 https://github.com/Cuis-Smalltalk/Numerics

# Download DrGeo

cd $cuisVersion
echo `pwd`

git clone --depth 1 https://github.com/hilaire/drgeo

# Install image for DrGeo IDE

cuisVersion=`cat drgeo/cuisVersion`
imageFolder=CuisImage
cuis=Cuis$cuisVersion
ide=drgeoIDE
VM=CuisVM.app/Contents/MacOS/squeak

cd $imageFolder
echo `pwd`

rm -f $ide.image $ide.changes $ide.user.* *.log
cp $cuis.image $ide.image
cp $cuis.changes $ide.changes
cd ..
echo `pwd`

$VM $imageFolder/$ide -s drgeo/src/setupDrGeoDevelopment.st 

# $VM $imageFolder/$ide

exit
