#!/bin/bash
source config.sh
OS=$(uname -s)
linux_pm=""
echo OS: $OS
if [ "$OS" = "Darwin" ]
then
    if [ -z "$(command -v brew)" ]
    then
        if [ -z "$(command -v curl)" ]
        then
            echo ERROR:
            echo do you even dev?
            echo you need to get curl
            exit 1
        fi
        if [ -z "$(command -v ruby)" ]
        then
            echo ERROR:
            echo do you even dev?
            echo you need ruby
            exit 2
        fi
        echo Installing brew
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        if [ $? -gt 0 ]
        then
            echo ERROR:
            echo Something when wrong with the brew install
            echo Find a nerd to fix this
            exit 3
        fi
    fi  
elif [ "$OS" = "Linux" ]
then
    if [ -n "$(command -v apt-get)" ]
    then
        linux_pm="apt-get"
    elif [ -n "$(command -v yum)" ]
    then
        linux_pm="yum"
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
