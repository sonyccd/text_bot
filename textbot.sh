#!/bin/bash
#checks if all args are given
if [ -z $1 ] || [ -z $2 ] || [ -z $3 ];then
    echo Must give phone number,
    echo number of texts, and min apart
    exit 4
fi
if [ -n $5 ]
then
    echo There is only four options
    exit 7
fi
reg='^[0-9]+([.][0-9]+)?$'
p_num=${1//[!0-9]/}
pings=$2
if ! [[ $pings =~ $reg ]]
then
    echo Number of messages must be a non negative number
    exit 5
fi
rate=$3
if ! [[ $rate =~ $reg ]]
then
    echo Rate of message must be non negative number
    exit 6
fi
#runs the dep install
bash dep_installer.sh
if [ $? -gt 0 ];then
    echo Dep installer error
    exit 1
fi
#test internet connection
wget -q --tries=10 --timeout=20 --spider http://google.com
if [ $? -ne 0 ]; then
    echo "You have no internet connection"
    exit 2
fi
#makes sure the user is not trying to send to many requests
if [ $pings -gt 75 ]; then
    echo "Can not send more than 75 messages"
    echo "at one time or with the same IP"
    echo "address. Change IP to send another round."
    exit 3
fi
#start tor in the background
tor &
#save the process id for latter shutdown
tor_pid=$!
#wait for 10sec to makesure tor is up
sleep 10
#clear the terminal of all the jargon
clear
#let the user know whats going on
echo "=========================="
echo "Phone Number:" $p_num
echo "Number of pings:" $pings
echo "Send every "$rate" min(s)"
#detemrin if usign default or user message
if [ -z "$4" ]
then
    echo "Using default message"
else
    echo "Using user message"
fi
echo "=========================="
#main loop
for((i=0;i<$pings;i++))do
    #config message
    if [ -n "$4" ]
    then
        msg=$4
    else
        msg=$(date)
        msg="The time and date is $msg"
    fi
    echo "Message:" $msg
    #make request to text belt
    ret=$(torsocks curl http://textbelt.com/text -d number=$p_num -d message="$msg"|jsawk 'return this.success')
    #check to see if text belt worked
    if [ "$ret" = "false" ]; then
        echo "ERROR: Did not send text"
        break
    fi
    #wait to run again, give user loading bar
    for j in {1..60};do
        sleep $rate
        printf "#"
    done
    printf "\n"
done
#stop tor
kill $tor_pid
