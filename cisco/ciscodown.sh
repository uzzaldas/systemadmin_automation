#!/usr/bin/expect -f
set timeout 20
set IPaddress [lindex $argv 0]
set Username "uzzal"
set Password "bdcom987"
set PORT [lindex $argv 1]
 
spawn ssh -o "StrictHostKeyChecking no" $Username@$IPaddress
 
expect "*assword: "
send "$Password\r"
 
expect "&gt;"
 
send "enable\r"
expect "*assword: "
send "$Password\r"
 
 
send "conf term\r"
 
 
send "interface FastEthernet 1/$PORT\r"
expect "#"
 
send "shut\r"
expect "#"
 
send "exit\r"
expect "#"
send "exit\r"
 
send "wr\r"
send "exit\r"
 
# Exit Script
exit
