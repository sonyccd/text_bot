#!/bin/bash
source config.sh
echo OS: $OS
if [ "$OS" = "Darwin" ] && [ -z "$(command -v brew)" ];then
    if [ -z "$(command -v curl)" ];then
        echo ERROR:
        echo do you even dev?
        echo you need to get curl
        exit 1
    fi
    if [ -z "$(command -v ruby)" ];then
        echo ERROR:
        echo do you even dev?
        echo you need ruby
        exit 2
    fi
    echo Installing brew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [ $? -gt 0 ];then
        echo ERROR:
        echo Something when wrong with the brew install
        echo Find a nerd to fix this
        exit 3
    fi    
fi
echo Installing deps
for i in "${dep[@]}";do
    if [ -n "$(command -v $i)" ];then
        echo $i Already installed
        continue;
    fi
    echo Installing $i
    if [ "$OS" = "Darwin" ];then
            brew install $i
            if [ $? -gt 0 ];then
                    echo Brew install error
                    exit 4
            fi
    fi
done
echo All deps installed
