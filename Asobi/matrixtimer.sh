#!/bin/bash

convertsecs() {
 ((h=${1}/3600))
 ((m=(${1}%3600)/60))
 ((s=${1}%60))
 printf "%02d:%02d:%02d\n" $h $m $s
}

read purpose

START=`date +%s`

# Put standard input in non-blocking mode
if [ -t 0 ]; then stty -echo -icanon -icrnl time 0 min 0; fi

#count=0
keypress=''
while [ "x$keypress" = "x" ]; do
  clear
  #let count+=1
  tput cup 28 70
  #echo -ne $count'\r'
  tput cup 30 70
  date
  tput cup 32 70
  echo $purpose
  tput cup 34 70
  END=`date +%s`
  ELAPSED=$(($END - $START ))
  echo $(convertsecs $ELAPSED)
  keypress="`cat -v`"
  sleep 1
done

if [ -t 0 ]; then stty sane; fi

echo "You pressed '$keypress' after $(convertsecs $ELAPSED) time on task $purpose"
exit 0
