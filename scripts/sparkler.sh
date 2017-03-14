#!/bin/sh
BASEDIR=$(dirname $0)

cd $BASEDIR/..

java -Denvironment=$SPARKLER_ENV -cp build/classes/main:build/libs/* com.tobykurien.sparkler.tools.SparklerTools $*

