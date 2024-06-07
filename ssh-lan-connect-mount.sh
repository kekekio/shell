#!/bin/bash
#Try to connect direct connected ssh-server, that was assigned with dhcp to 10.42.0./24, and mount it using sshfs to $2
# подключение по ssh к подключенному напрямую устройству, и маунт его в $2
# \args: 
# 	\param[in] $1 - password
# 	\param[in] $2 - mountpoint

PASSWORD=$1
MOUNT_POINT=$2
IP_VAR="$3"
umount -l $MOUNT_POINT || true # "|| true" - is ignoring errors
#
#do-while loop
while :;
	if [[ ! -z "$IP_VAR" ]]; then
		break
	fi
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

echo "Try to connect to $IP_VAR"
ssh-keygen -R $IP_VAR || true # "|| true" - is ignoring errors

echo $PASSWORD | sshfs -o allow_other -o password_stdin -oStrictHostKeyChecking=accept-new root@$IP_VAR:/ $MOUNT_POINT
sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=accept-new root@$IP_VAR
umount -l $MOUNT_POINT || true # "|| true" - is ignoring errors

