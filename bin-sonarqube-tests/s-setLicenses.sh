#!/bin/sh

# Need to have $SONARSOURCE_PLUGIN_LICENSES_URL defined as environment variable

setLicense() {
  echo "gathering license for $1"
  #LICENSE=`curl -s $SONARSOURCE_PLUGIN_LICENSES_URL/$1.txt | tr -d '\r\n'`
  LICENSE=`more $REPOS/licenses/it/$1.txt | tr -d '\r\n'`
  # multiple curl because all the plugins do not have the same property...
  echo "pushing license to SQ"
  curl -s -u admin:admin -X POST "http://localhost:9000/api/properties?id=$1.license.secured&value=$LICENSE"
  curl -s -u admin:admin -X POST "http://localhost:9000/api/properties?id=sonar.$1.license.secured&value=$LICENSE"
  curl -s -u admin:admin -X POST "http://localhost:9000/api/properties?id=sonarsource.$1.license.secured&value=$LICENSE"

  # in case of 2 SQ instances running on the same machine
  curl -s -u admin:admin -X POST "http://localhost:9100/api/properties?id=$1.license.secured&value=$LICENSE"
  curl -s -u admin:admin -X POST "http://localhost:9100/api/properties?id=sonar.$1.license.secured&value=$LICENSE"
  curl -s -u admin:admin -X POST "http://localhost:9100/api/properties?id=sonarsource.$1.license.secured&value=$LICENSE"
  echo ""
}

licenselist="views sqale devcockpit report governance abap cpp cobol objc plsql pli rpg swift vbnet vb tsql"
for lic in $licenselist
do
   setLicense $lic
done
