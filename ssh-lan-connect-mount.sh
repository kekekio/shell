#!/bin/bash
#Try to connect direct connected ssh-server and mount it using sshfs


#
#do-while loop
while :;
do 
IP_VAR=$(nmap 10.42.0.0/24 --exclude 10.42.0.1 | 
	grep "Nmap scan report for" | 
	grep -oh -E "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" | 
	head -n 1); 
if [ -z "$IP_VAR" ]; then
	
	echo "Nmap hasn't found any devices: IP_VAR is NULL" 
	echo "Continue" 
else
	break
fi
	
done

MOUNT_POINT=$2
PASSWORD=$1
echo "Try to connect to $IP_VAR"
echo $PASSWORD | sshfs -o password_stdin root@$IP_VAR:/ $MOUNT_POINT
sshpass -p $PASSWORD ssh root@$IP_VAR
