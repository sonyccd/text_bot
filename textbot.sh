#!/bin/bash
if [ -z $1 ] || [ -z $2 ] || [ -z $3 ];then
    echo Must give phone number,
    echo number of texts, and min apart
    exit 4
fi
bash dep_installer.sh
if [ $? -gt 0 ];then
    echo Dep installer error
    exit 1
fi
wget -q --tries=10 --timeout=20 --spider http://google.com
if [ $? -ne 0 ]; then
    echo "You have no internet connection"
    exit 2
fi
if [ $2 -gt 75 ]; then
    echo "Can not send more than 75 messages"
    echo "at one time or with the same IP"
    echo "address. Change IP to send another round."
    exit 3
fi
tor &
tor_pid=$!
sleep 10
clear
echo "=========================="
echo "Phone Number:" $1
echo "Number of pings:" $2
echo "Send every "$3" min(s)"
echo "=========================="
for((i=0;i<$2;i++))do
    msg=$(date)
    msg="The time and date is $msg"
    echo "Message:" $msg
    ret=$(torsocks curl http://textbelt.com/text -d number=$1 -d message="$msg"|jsawk 'return this.success')
    if [ "$ret" = "false" ]; then
        echo "ERROR: Did not send text"
        break
    fi
    for j in {1..60};do
        sleep $3
        printf "#"
    done
    printf "\n"
done
kill $tor_pid
