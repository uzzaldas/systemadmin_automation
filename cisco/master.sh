#!/bin/bash
# Script to manage CISCO 3750/xxxx model switch via bash script.
# It can print all errors related to script, it can perform given Action like UP/DOWN for any given port on require switch.
# Comes handy like you can integrate it with PHP  or any frontend.
# I made it for specific network where OP wanted to UP/DOWN the PORT via sending SMS to linux base system, and it will perform
# action as directed.
# Syed Jahanzaib
# aacable at hotmail dot com
# https://aacable.wordpress.com
# Created = 11-DEC-2015
# Last Mofidied = 11-DEC-2015
 
# Enable set -x to enable SCRIPT DEBUG mode.
#set -x
 
# Setting various Variables
 
# SWITCH IP Address VALUE
# Check VAR1 and match value with valid data
if [ "$1" != "SW1" ] && [ "$1" != "SW2" ];
then
echo "Switch Value must be SW1 or SW2
Usage Example:
 
./master.sh SW1 24 UP"
 
exit 1; fi
 
# SWITCH IP ADDRESSES. CHANGE IT AS REQUIRED / ZAIB
SW1IP="192.168.0.100"
SW2IP="192.168.0.2"
 
###########################################
# MAKE SURE YOU CHANGE THIS OID AS REQUIRED. SOME SWITCHES LIKE MB/GB MAY HAVE DIFFERNT OID IN UR NETWORK.
PORTOID="1.3.6.1.2.1.2.2.1.8.101"
# To get Port description, friendly text for port
PORTDESC="1.3.6.1.2.1.31.1.1.1.18.101"
 
# SWITCH IP variable
# Check VAR1 and match value with valid data
if [ "$1" = "SW1" ] ; then
SWITCH="$SW1IP"
fi
 
if [ "$1" == "SW2" ] ; then
SWITCH="$SW2IP"
fi
 
# SWITCH Variable
# Check VAR1 and match value with valid data
PORT="$2"
if [[ "$PORT" =~ ^[0-9]+$ ]] && [[ "$PORT" -le 48 ]] ; then
echo
else
echo "PORT value not correct. It must be in numeric format like 01 upto max 48 etc
Usage Example:
 
./master.sh SW1 24 UP"
 
exit 1; fi
 
# ACTION Variable
# Check VAR1 and match value with valid data
ACTION="$3"
 
if [ "$ACTION" != "UP" ] && [ "$ACTION" != "DOWN" ];
then
echo "Action Value not correct, it must be either UP or DONW
Usage Example:
 
./master.sh SW1 24 UP"
 
exit 1; fi
 
# Check PING status of switch.
# Check if Mikrotik is accessibel or not, if not then EXIT immediately with error / zaib
if [[ $(ping -q -c 2 $SWITCH) == @(*100% packet loss*) ]]; then
echo "ALERT ..... $SWITCH is DOWN. cannot process further. check connectivity."
exit
else
echo "$SWITCH is accessible OK."
fi
 
# Port Description infor to get more accurate idea about port info
DESCR=`snmpwalk -v1 -c public $SWITCH $PORTDESC$PORT | sed -e 's/\"//' | sed -e 's/\"//' | awk '{print $4,$5,$6,$7,$8,$9}'`
 
# Print Data gaterhed
echo -e "Command Data Received.
SWITCH = $1 = $SWITCH
PORT = $PORT
PORT DESCR = $DESCR
REQUIRED ACTION = $ACTION"
 
# Query Present / Current PORT Status
PORTQUERY=`snmpwalk -v1 -c public $SWITCH $PORTOID$PORT | awk '{print $4}'`
RESULT="$PORTQUERY"
if [ "$RESULT" == "1" ]; then
PRESULT="UP"
echo -e "PORT Current Status = $PRESULT"
else
PRESULT="DOWN"
echo -e "PORT Current Status = $PRESULT"
fi
 
# Match condition. If Action required is UP and port is already UP, then NO ACTION, just exit.
PORTQUERY=`snmpwalk -v1 -c public $SWITCH $PORTOID$PORT | awk '{print $4}'`
RESULT="$PORTQUERY"
if [ "$RESULT" == "1" ] && [ "$ACTION" == 'UP' ];
then
echo "Port $PORT is already UP. No action is required. Exiting ..."
fi
 
# Match condition. If Action required is UP and port is DOWN , then run UP script.
if [ "$RESULT" == "2" ] && [ "$ACTION" == 'UP' ];
then
echo -e "PORT $PORT $PRESULT. doing UP Action..."
/temp/ciscoup.sh  $SWITCH $PORT $ACTION
#> /dev/null 2>&1
fi
 
# Match condition. If Action required is DOWN and port is also DOWN , then NO ACTION, Just EXIT.
if [ "$RESULT" == "2" ] && [ "$ACTION" == 'DOWN' ];
then
echo "PORT $PORT is already DOWN, no action required. Exiting ..."
fi
 
 
# Match condition. If Action required is DOWN and port is UP , then eyb UP script.
if [ "$RESULT" == "1" ] && [ "$ACTION" == 'DOWN' ];
then
echo "Doing DOWN Action..."
/temp/ciscodown.sh $SWITCH $PORT $ACTION
#> /dev/null 2>&1
fi
 
# PRINT Final Status (after the above actions are done, so we can have idea whats the final result)
PORTQUERY=`snmpwalk -v1 -c public $SWITCH $PORTOID$PORT | awk '{print $4}'`
RESULT="$PORTQUERY"
if [ "$RESULT" == "1" ]; then
echo
echo "FINAL RESULT = UP
~~~~~~~~~~~~~~~~~"
 
else
echo
echo "FINAL RESULT = DOWN
~~~~~~~~~~~~~~~~~"
fi
 
# SCRIPT END.
# EXIT
# JZ
