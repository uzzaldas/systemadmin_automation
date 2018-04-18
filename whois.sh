#!/bin/bash
# Script for whois with details
read -p 'Enter IP address : ' inputip
hostname=v4.whois.cymru.com
whois -h $hostname " -c -p $inputip"
