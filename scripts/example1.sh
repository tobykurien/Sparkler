#!/bin/sh
BASEDIR=$(dirname $0)

cd $BASEDIR/..

java -cp build/classes/main:/build/libs/* -Denvironment=development com.tobykurien.sparkler_example.Example1
