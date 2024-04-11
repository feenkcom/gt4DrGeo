#! /bin/sh -x
# Just run Dr Geo after having built it
#
# Run this either from the parent directory or from within the Cuis build.
#
# Revised: 2024-03-28 2024-04-03

D=`dirname "$0"`
cd "$D"

D1=Cuis/Cuis-Smalltalk-Dev
D2=Cuis-Smalltalk-Dev

if test -d $D1
then
	DEV=$D1
elif test -d $D2
then
	DEV=$D2
else
	echo 'Could not find $D2'
	exit 1
fi

cd $DEV
echo `pwd`

imagePath=CuisImage
ide=drgeoIDE
# VM=CuisVM.app/Contents/Linux-x86_64/squeak
VM=CuisVM.app/Contents/MacOS/Squeak

$VM $imagePath/$ide.image
exit

$VM $imagePath/$ide.image -s drgeo/src/setupDrGeoDevelopment.st 
exit
