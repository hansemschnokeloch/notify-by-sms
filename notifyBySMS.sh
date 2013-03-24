#!/bin/bash

###
## This script sends SMS using the http API of OVH
## It can be used by nagios to alert with SMS when something goes wrong
###

###
## Arguments stuff
###
if [ $# == 1 ] ; then
	message=$1" - "
else
	echo "Usage : $0 message"
	echo "Be careful, use single quotation mark arround the message, otherwise the script will only take the first word"
	exit 2
fi


###
## Some variables to configure here
###

# API parameters
urlCGI="https://www.ovh.com/cgi-bin/sms/http2sms.cgi"
idCompte="sms-maXXXXX-X"
login="XXXXXXXXXX"
passwd="PASS"
from="FROM_SBY"			# you'll need to configure a "sender" on OVH
to="YOUR_PHONE_NUMBER" 		# for instance : 003362762XXXX
contentType="text/plain"

# I added a delay between 2 SMS to avoid sending a lot of SMS
# in a short period of time (useful when used with nagios for instance)
delay=7200 			# in second (3600 = 1 hour)
tmpFile=/tmp/NotifyBySMS.last   # kind of a lock file

###
## Important stuff down below
###

if test -w $tmpFile ; then
	lastSMS=`head -n 1 $tmpFile`
	current=`date +%s`
	intervalle=$(($current - $lastSMS))
	if test $(($current - $lastSMS)) -gt $delay ; then
		retour=`wget -q -O - "$urlCGI?smsAccount=$idCompte&login=$login&password=$passwd&from=$from&to=$to&contentType=$contentType&message=$message" | cat`
		date +%s > $tmpFile
	else
		exit 0
	fi
else
	date +%s > $tmpFile
fi

# Check if the SMS is sent or not, most of the time it failed when you don't have any credit left on your account
if echo $retour | grep OK ; then
        echo "SMS sent !"
	exit 0
else
        echo "Something went wrong, sorry about that."
	exit 1
fi

