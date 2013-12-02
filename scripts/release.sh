#!/bin/sh
BASEDIR=$(dirname $0)
cd $BASEDIR/..

if [ $# -ne 1 ]
then
    echo "Usage - $0  [release name]"
    echo " e.g. - $0  sparkler_v0.0.1"
    exit 1
fi

rm -rf releases/$1
mkdir releases/$1
mkdir releases/$1/libs
cp -r libs/* releases/$1/libs
cp -r assets/* releases/$1

cd $BASEDIR/../bin
jar cf $1.jar *
mv $1.jar ../releases/$1/libs

cd ../releases/
zip -r $1.zip $1/*
rm -rf $1

echo Done!

