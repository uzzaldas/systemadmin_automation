#!/usr/bin/expect -f
set timeout 20
set IPaddress [lindex $argv 0]
set Username "zaib"
set Password "zaib"
set PORT [lindex $argv 1]
 
spawn ssh -o "StrictHostKeyChecking no" $Username@$IPaddress
 
expect "*assword: "
send "$Password\r"
 
expect "&gt;"
 
send "enable\r"
expect "*assword: "
send "$Password\r"
 
 
send "conf term\r"
 
 
send "interface gigabitEthernet 1/0/$PORT\r"
expect "#"
 
send "shut\r"
expect "#"
 
send "no shut\r"
expect "#"
 
send "exit\r"
expect "#"
send "exit\r"
 
expect "&gt;"
send "wr\r"
send "exit\r"
 
# Exit Script
exit
