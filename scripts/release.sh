#!/bin/sh
BASEDIR=$(dirname $0)
cd $BASEDIR/..

rm -rf releases/$1
mkdir releases/$1
mkdir releases/$1/libs
cp -r libs/* releases/$1/libs
cp -r assets/* releases/$1

cd $BASEDIR/../bin
jar cf sparkler_$1.jar *
mv sparkler_$1.jar ../releases/$1/libs

cd ../releases/
zip -r sparkler_$1.zip $1/*
rm -rf $1

echo Done!

