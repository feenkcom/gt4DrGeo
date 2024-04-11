#! /bin/sh -x
#
# Build and install Dr. Geo in a Cuis-Smalltalk developer environment.
#
# NB: AFter building, you must run `DrGeoSystem beDevelopment`
# to properly initialize DrGeo.
#
# Adapted from GH README
#
# Main page: https://www.gnu.org/software/dr-geo/
# GH repo: https://github.com/hilaire/drgeo
# 
# There is no Mac DrGeo download.
# This script has been adapted from the GH instructions to work on a Mac.

# CONFIGURE THESE!
# This is the cuis version
# https://github.com/Cuis-Smalltalk/$cuisVersion
# And the image version is in
# https://github.com/Cuis-Smalltalk/$cuisVersion/CuisImage
#
# Revised: 2024-03-28

D=`dirname "$0"`
cd "$D"
echo `pwd`

# Install Cuis

mkdir Cuis
cd Cuis
echo `pwd`

# git clone https://github.com/Cuis-Smalltalk/$cuisVersion

git clone --depth 1 https://github.com/Cuis-Smalltalk/Cuis-Smalltalk-Dev
git clone --depth 1 https://github.com/Cuis-Smalltalk/Cuis-Smalltalk-UI
git clone --depth 1 https://github.com/Cuis-Smalltalk/Erudite
git clone --depth 1 https://github.com/Cuis-Smalltalk/Numerics
git clone --depth 1 https://github.com/Cuis-Smalltalk/Parsers
git clone --depth 1 https://github.com/Cuis-Smalltalk/SVG

# Download DrGeo

cd Cuis-Smalltalk-Dev
echo `pwd`

git clone --depth 1 https://github.com/hilaire/drgeo

# startIDE.sh -- adapted for Mac

imagePath=CuisImage
# Cuis release
release=`cat drgeo/cuisRelease`
# version number, when dealing with rolling release
version=`ls $imagePath/Cuis$release-????.image | cut -d - -f 2 | cut -d . -f 1`
cuis=Cuis$release-$version

ide=drgeoIDE
# VM=CuisVM.app/Contents/Linux-x86_64/squeak
VM=CuisVM.app/Contents/MacOS/Squeak

# Install image for DrGeo IDE
cd $imagePath
rm $ide.image $ide.changes $ide.user.* *.log
cp $cuis.image $ide.image
cp $cuis.changes $ide.changes
cd -

# $VM $imagePath/$ide -s drgeo/src/setupDrGeoDevelopment.st 
$VM $imagePath/$ide.image -s drgeo/src/setupDrGeoDevelopment.st 


exit 0
