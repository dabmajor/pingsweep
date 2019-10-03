#!/bin/bash
# pingsweep for class C CIDR only /24 to /31
# pingsweep.sh [<network address>/CIDR]
# pingsweel.sh 10.11.1.0/24

network_address=$(echo $1 | cut -d / -f 1)
cidr=$(echo $1 | cut -d / -f 2)
printf "[*] Performing ping sweep on "$network_address"/"$cidr"\n"

# starts off at 1, because all multiples will be done of 2
host_count=1

# iterate through the number of network bits set on the CIDR
# subtract cidr from 32 to figure out number of bits used for hosts
for i in $(seq 1 $((32-$cidr))); do host_count=$(($host_count * 2)); done;

printf "[-] Total # of hosts: "$host_count"\n"
start=1
stop=$(($host_count - 2))
printf "[-] Usable range: 1 - "$stop"\n"
printf "[*] Pinging range now!\n"

# grab first 3 octects of the network address
network_only=$(echo $network_address | cut -d'.' -f 1-3)

# issue ping command for range of targets
for i in $(seq $start $stop)
do
	target=$network_only"."$i
	printf "[*] Pinging "$target" now!\n"
	result=$(ping -c 1 -W 1 $target | grep "packets" | cut -d" " -f 6)
	if [ $result == "0%" ]
	then
		printf "SUCCESS! "$target" is up!\n"
	fi
	# BAD:	1 packets transmitted, 0 received, 100% packet loss, time 0ms
	# GOOD:	1 packets transmitted, 1 received, 0% packet loss, time 0
done
