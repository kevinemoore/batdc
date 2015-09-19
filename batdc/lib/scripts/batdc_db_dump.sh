#!/bin/bash

# Add to crontab (currently installed in ~kmoore)
# 0 * * * * ~/batdc_db_dump.sh <DB PASSWORD>
backup=~/Dropbox/database/batdc_rails_db_$(date -d "today" +"%Y-%m-%d-%H%M").sql
mysqldump --user rails --password=$1 rails > $backup
cp $backup ~/Dropbox/database/batdc_rails_db_$(date -d "today" +"%Y-%m-%d").sql
yesterday=~/Dropbox/database/batdc_rails_db_$(date -d "yesterday" +"%Y-%m-%d-%H%M").sql
if [ -f $yesterday ]
  then
    rm $yesterday
fi

echo $backup >> batdc_backup.log
