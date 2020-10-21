#!/bin/bash

## Description: sync fileadmin and DB from Remote Server
## Usage: sync-example
## Example: "ddev sync-example"

## !! PLEASE SET TO THE RIGHT VALUES !!
TYPO3_CONTEXT='Development'

## Host aus der .ssh/config
SSH_HOST='###.stage'

PUBLIC_DIR='/var/www/html/'
BACKUP_DIR='/home/davitec/backup/'

DB_NAME='usrdb_***'
DB_USER='user***'
DB_PW='###'
DB_HOST='###'

set -x

rsync -av -e ssh --delete ${SSH_HOST}:${PUBLIC_DIR}fileadmin/ ./public/fileadmin/
#rsync -av -e ssh --delete ${SSH_HOST}:${PUBLIC_DIR}uploads/ ./public/uploads/

ssh ${SSH_HOST} "rm ${BACKUP_DIR}${DB_NAME}-sync.sql.gz"

ssh ${SSH_HOST} "mysqldump --single-transaction --quick --lock-tables=false -u${DB_USER} -p'${DB_PW}' ${DB_NAME} | gzip > ${BACKUP_DIR}${DB_NAME}-sync.sql.gz"

cd ./.ddev
mkdir -p backup
scp ${SSH_HOST}:${BACKUP_DIR}${DB_NAME}-sync.sql.gz ./backup/

ddev export-db -z -f ./backup/mysql-db.sql.gz

ddev import-db --src=./backup/${DB_NAME}-sync.sql.gz
