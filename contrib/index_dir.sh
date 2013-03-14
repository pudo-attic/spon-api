#!/bin/bash

echo $1
FILES=`find $1 -type f -name '8*.xml'`

for FILE in $FILES; do
  echo "Indexing $FILE..."
  curl -X POST -d @$FILE $SPON_BASE_URL/import?secret=$SPON_IMPORT_SECRET
done
