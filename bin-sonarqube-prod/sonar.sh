#!/bin/sh

SONAR_PROPERTIES_FILE=$SOFTWARE_FOLDER/Sonar/current/conf/sonar.properties

if [ -z "$3" ]
then 
  SONAR_DB="localhost"
else
  SONAR_DB="$3"
fi

if [ "$1" = "start" ]
then 
  # print out properties for the correct DB
  if [ "$2" = "P" ] 
  then
    echo "sonar.jdbc.url=jdbc:postgresql://$SONAR_DB:15432/sonar" >> $SONAR_PROPERTIES_FILE
  else
    if [ "$2" = "M" ] 
    then
      echo "sonar.jdbc.url=jdbc:mysql://$SONAR_DB:13306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true" >> $SONAR_PROPERTIES_FILE
    else
      if [ "$2" = "O" ] 
      then
        echo "sonar.jdbc.url=jdbc:oracle:thin:@$SONAR_DB/XE" >> $SONAR_PROPERTIES_FILE
      else
        echo "sonar.jdbc.url=jdbc:h2:tcp://$SONAR_DB:9092/sonar" >> $SONAR_PROPERTIES_FILE
      fi
    fi
  fi
fi

$SOFTWARE_FOLDER/Sonar/current/bin/$SONAR_WRAPPER_FOLDER/sonar.sh $1
