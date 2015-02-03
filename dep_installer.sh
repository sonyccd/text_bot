#!/bin/bash
#load config file with dep array
source dep_config.sh
#what os am i
OS=$(uname -s)
linux_pm=""
echo OS: $OS
#if a mac
if [ "$OS" = "Darwin" ]
then
    #do we have brew
    if [ -z "$(command -v brew)" ]
    then
        #do we have curl
        if [ -z "$(command -v curl)" ]
        then
            echo ERROR:
            echo do you even dev?
            echo you need to get curl
            exit 1
        fi
        #do we have ruby
        if [ -z "$(command -v ruby)" ]
        then
            echo ERROR:
            echo do you even dev?
            echo you need ruby
            exit 2
        fi
        echo Installing brew
        #install brew
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        if [ $? -gt 0 ]
        then
            echo ERROR:
            echo Something when wrong with the brew install
            echo Find a nerd to fix this
            exit 3
        fi
    else
        echo Updating Brew
        brew update
    fi  
#if i am linux
elif [ "$OS" = "Linux" ]
then
    #am i using apt-get or yum
    if [ -n "$(command -v apt-get)" ]
    then
        linux_pm="apt-get"
        echo Updating apt-get
        apt-get update
    elif [ -n "$(command -v yum)" ]
    then
        linux_pm="yum"
        echo Updating yum
        yum update
    else
        echo ERROR:
        echo Do you even dev?!
        echo you really need a package manager
        exit 5
    fi
else
    echo ERROR:
    echo Do you have an OS?!
    exit 7
fi
echo Installing deps
#loop over deps and install based on os type and package manager
for i in "${dep[@]}";do
    if [ -n "$(command -v $i)" ]
    then
        echo $i Already installed
        continue;
    fi
    echo Installing $i
    if [ "$OS" = "Darwin" ]
    then
        brew install $i
        if [ $? -gt 0 ]
        then
            echo ERROR:
            echo Brew install error
            exit 4
        fi
    elif [ "$OS" = "Linux" ]
    then
        sudo $linux_pm install $i
        if [ $? -gt 0 ]
        then
            echo ERROR:
            echo $linux_pm install error
            exit 6
        fi
    fi
done
echo All deps installed
