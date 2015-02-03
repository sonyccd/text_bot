# text_bot

##Introduction
This is text_bot.  It is a bash script with tor that will send the time and date (unless you change the message) to the phone number of your choice over and over again.

##How to use
To run use

```
./textbot.sh <phone #> <# of transmits> <# of times a minute>
```

###Notes
The server used is textbelt.com.  It does not allow more than 75 tranmits a day and no more thant 3 messages per number in a 3 minute period.  For this reason the script will not let you send more thant 75 at a time.  If you restart the program tor is started and you will get a new ip.  So if you feel like a real jerk then you can just put the script in a for loop and keep running it over and over.

###dep_installer.sh
This is a script I created to make sure that you have all needed dependencies to run text_bot. It will run on mac or linux.  If dependencies are missing it will use the package manager of your machine to install them.

###Disclaimer
I am not liable for any uses of this code.  Use at your own risk to loss of friends and family.
