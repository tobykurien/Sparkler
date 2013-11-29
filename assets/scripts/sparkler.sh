#!/bin/sh
BASEDIR=$(dirname $0)

cd $BASEDIR/..

java -cp bin:libs/* com.tobykurien.sparkler.tools.SparklerTools $*

