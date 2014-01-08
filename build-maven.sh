#!/bin/sh
mvn install:install-file -Dfile=libs/activejdbc-1.4.9-tobykurien-2.jar -DgroupId=org.javalite -DartifactId=activejdbc-tobykurien-2 -Dversion=1.4.9 -Dpackaging=jar
mvn compile

