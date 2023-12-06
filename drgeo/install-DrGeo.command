#! /bin/sh -x
#
# Instructions to install Dr. Geo in a Cuis-Smalltalk developer environment.
#
# Downloaded from:
# https://bazaar.launchpad.net/~drgeo-developers/drgeo/trunk/view/head:/install.txt
#
# Adapted 2023-12-04 by ON for the Mac.

# NB: This script requires that bzr be installed (used in step 3).
# https://ports.macports.org/port/bzr/

# 0. This directory, i.e., where GT will be installed.

D=`dirname "$0"`
cd "$D"

# ==================================================
# 1. Set up your Cuis-Smalltalk dev environment

C="$D/Cuis"
mkdir "$C"
cd "$C"

# Install Cuis image and packages

echo "*** Installing Cuis image and packages ***"

git clone --depth 1 https://github.com/Cuis-Smalltalk/Cuis-Smalltalk-Dev.git

# NB: these are already done by the clonePackageRepos script
# git clone --depth 1 https://github.com/Cuis-Smalltalk/Cuis-Smalltalk-UI.git
# git clone --depth 1 https://github.com/Cuis-Smalltalk/Erudite.git
# git clone --depth 1 https://github.com/Cuis-Smalltalk/Numerics.git

DEV="$C/Cuis-Smalltalk-Dev"
cd "$DEV"

./clonePackageRepos.sh
./pullAllRepos.sh

# ==================================================
# 2. Install Virtual Machine

# Instead of doing this, we must download the Mac VM from https://github.com/OpenSmalltalk/opensmalltalk-vm and place Squeak.app in the directory $D

cd "$DEV"

VM="$C/VM"
mkdir "$VM"
cp "$D/Squeak.app/Contents/MacOS/Squeak" "$VM/squeak"

# echo "*** Installing Virtual Machine ***"

# wget -O cogspur.tgz https://github.com/OpenSmalltalk/opensmalltalk-vm/releases/latest/download/squeak.cog.spur_linux64x64.tar.gz
# tar -zxvf cogspur.tgz
# mv ./sqcogspur64linuxht ./cogspur

# ==================================================
# 3. Fetch the Dr. Geo repository, with source and script

echo "*** Fetching the Dr. Geo repository, with source and script ***"

cd "$DEV"

bzr branch lp:drgeo
# ==================================================
# 4. Start the Dr. Geo IDE

echo "*** Starting the Dr. Geo IDE ***"
./drgeo/startIDE.sh

# ==================================================
exit

# Actually this will just copy the image, but starting squeak will not work due to Mac permissions issues, it seems. The script just hangs when it gets to the last line:

../VM/squeak drgeoIDE -s drgeo/src/setupDrGeoDevelopment.st

# So instead start Squeak.app  manually with the drgeoIDE.image

# Then open a workspace and run

Compiler evaluate: (Smalltalk imageName asFileEntry parent / 'drgeo' / 'src' // 'setupDrGeoDevelopment.st') textContents

# A new image drgeoIDE.image is built. To start Dr Geo in the image run:

DrGeoSystem beDevelopment.
DrGeo new.

# NB: Maybe you want to set Preferences>Size of GUI elements>32 ...

