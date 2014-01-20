#!/bin/bash
#
# syncDbToLocal.sh
# 
# Description: syncs a remote database to localhost assuming that the
#              database name, username and password are the same
#              in the remote server and localhost
#
# Use this script at your own risk, this was written for personal usage 
# 
# @kirai
#
# TODO: Handle parameters using getopt instead of trusting the order

printUsage() {
    echo "Usage: $0 [options] [required params]"
    echo "Required Params:"
    echo "    first: SSH USERNAME"
    echo "    second: SSH SERVER"
    echo "    third: MYSQL USERNAME"
    echo "    forth: MYSQL PASSWORD"
    echo "    fifth: MYSQL DATABASE"
    echo "Options (Sixth Parameter):"
    echo "    -c,--clean: deletes mysqldump .sql files after being downloaded"
    echo "    -h,--help: print help"
    exit
}

doClean=0
case "$6" in
  h|help|-h|-help|--help)
	  printUsage
	  exit
	  ;;
  c|clean|-c|--clean)
	  doClean=1
  	;;
  *)
	  ;;
esac

if [ $# -lt 5 ]; then
  echo -ne "$#Error: you should provide a "
  case "$#" in
    0)
      echo "SSH USERNAME as first parameter" a>&2
      printUsage
      exit -1
      ;;
    1)
      echo "SSH SERVER as second parameter" a>&2
      printUsage
      exit -1
      ;;
    2)
      echo "MYSQL USERNAME as third parameter" a>&2
      printUsage
      exit -1
      ;;
    3)
      echo "MYSQL PASSWORD as forth parameter" a>&2
      printUsage
      exit -1
      ;;
    4)
      echo "SSH DATABASE as fifth parameter" a>&2
      printUsage
      exit -1
      ;;
    *)
	    ;;
  esac
fi

SSH_USERNAME=$1
SSH_SERVER=$2
MYSQL_USERNAME=$3
MYSQL_PASSWORD=$4
MYSQL_DATABASE=$5

NOW=$(date +"%H%M%S-%m-%d-%Y")
OUTPUT_SQL_FILENAME=$MYSQL_DATABASE-$NOW.sql

echo "--------------------------------------------------------------"
echo "Downloading $MYSQL_DATABASE database from $SSH_SERVER"
echo "--------------------------------------------------------------"

ssh -q -t $SSH_USERNAME@$SSH_SERVER mysqldump --default-character-set=utf8 -u$MYSQL_USERNAME -p$MYSQL_PASSWORD $MYSQL_DATABASE > $OUTPUT_SQL_FILENAME
if [[ $? != 0 ]]; then
  echo "Failed to download DB data"
  exit -1
else
  echo "Finished downloading $MYSQL_DATABASE"
fi

echo "--------------------------------------------------------------"
echo "Overwriting $MYSQL_DATABASE on localhost using downloaded data"
echo "--------------------------------------------------------------"

mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USERNAME'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD'"

mysql -u$MYSQL_USERNAME -p$MYSQL_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE";

mysql -u$MYSQL_USERNAME -p$MYSQL_PASSWORD $MYSQL_DATABASE < $OUTPUT_SQL_FILENAME

if [[ $? != 0 ]]; then
  echo "Failed to import the new database data into the local database"
fi

if [ $doClean -ne 0 ]; then
  rm $OUTPUT_SQL_FILENAME
fi
 
echo "Finished backuping your remote $MYSQL_DATABASE database to your local $MYSQL_DATABASE database"
exit 0
