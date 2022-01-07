#!/bin/bash
echo $1
echo $2
function MyFirstFunction {
        LOCKFILE=/var/lock/ohw09.lock
if [[ -f $LOCKFILE ]]; then
  echo "script is already locked!" >&2
  exit 1
fi
touch $LOCKFILE
}
MyFirstFunction
MailFileText=/var/tmp/ohw09.txt
MyLogFile=/home/vagrant/hw09/access-4560-644067.log
touch $MailFileText
StartDate=`cat $MyLogFile | cut -f 4 -d ' ' | head -n 1 | sed 's/^\[//'`
{ echo "временной промежуток с $StartDate по $(date)"
echo "список IP адресов из Х заданных строк с количестом запросов от них в порядке убывания"
echo "Ip                  value"
cat $MyLogFile | cut -f 1 -d' ' | sort | uniq -c | sort -r -n | head -n "$1" | sed -r 's/(.*) (.*)/\2 \1/'
echo " "
echo "список запрашиваемых адресов из Y строк + количество запросов с момента последнего запуска скрипта с наибольшим количеством запросов"
echo "name                value"
cat $MyLogFile | cut -f 11 -d ' ' | grep -v "-" | awk -F[/:] '{print $4}' | sed 's/"//' | sort | uniq -c | sed -r 's/(.*) (.*)/\2 \1/' | head -n "$2"
echo "список всех ошибок с момента последнего запуска"
cat $MyLogFile | cut -f 9 -d ' ' | grep -v 200 | grep -v "-" | sort | uniq
echo "список всех кодов возврата + количество с момента последнего запуска"
cat $MyLogFile | cut -f 9 -d ' ' | grep -v "-" | sort | uniq -c | sed -r 's/(.*) (.*)/\2 \1/'
} >> $MailFileText
cat $MailFileText | mail -s "log" root@localhost
#rm $MailFileText
trap 'rm $LOCKFILE' EXIT

