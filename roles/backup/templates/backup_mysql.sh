#!/bin/bash

USER=root
PASSWORD=secret
OUTPUT="/usr/backup_mysql"

databases=`mysql --user=$USER --password=$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != _* ]] ; then
       echo "Dumping database: $db"
       mysqldump --force --opt --user=$USER --password=$PASSWORD --databases $db > $OUTPUT/`date +%Y%m%d`.$db.sql
       gzip $OUTPUT/`date +%Y%m%d`.$db.sql
 fi
done

find $OUTPUT/  -mtime +7 -delete
