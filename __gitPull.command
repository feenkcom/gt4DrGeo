#! /bin/sh
D=`dirname "$0"`
cd "$D"

git pull
git gc
