#!/bin/bash

# Put standard input in non-blocking mode
if [ -t 0 ]; then stty -echo -icanon -icrnl time 0 min 0; fi

count=0
keypress=''
while [ "x$keypress" = "x" ]; do
  clear
  let count+=1
  echo -ne $count'\r'
  keypress="`cat -v`"

  tput cup 30 70
  date
  tput cup 32 70
  sleep 1
done

if [ -t 0 ]; then stty sane; fi

echo "You pressed '$keypress' after $count loop iterations"
echo "Thanks for using this script."
exit 0

