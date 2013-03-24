# Notify by SMS for Nagios (and eventually other scripts !)

This little script uses the OVH http api to send SMS to alert you when something goes wrong with your server.
In fact, it's just a bash code to use the SMS API of OVH, you can use this script for other stuff than nagios. However, I think Nagios is a good example because it's very handy to have SMS notification.

## How to use this script ?

First of all, you need to change the parameter for the API. For instance, you need to specify your sender account (which you can create and manage on OVH's website), your password, your phone number to received the alert and your login (usually the same as your sender username).

Then, you call the script this way : ./notifyBySMS 'your message with single quote'
The single quotes are quite important, otherwise the script will only take the first word.

Bonus : I added a delay to avoid sending a lot of SMS in a short period of time. By default, it's an 2 hours (7200 seconds in the script). I've done that because I had a lot of problem with nagios, I got 40 SMS in less than 2 hours and it's expensive ! Otherwise, be careful with your nagios configuration, you can configure the notification stuff for instance (I was too lazy to do it so I added the delay ;-)

