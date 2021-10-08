#!/bin/bash

echo 'What file would you like to open?'
read in_pcap
#Pull top src ip and dst port and calculate amount per ip/port
tshark -r "$in_pcap" -T fields -e ip.src -e tcp.dstport | sort | uniq -c | sort -k 1 -n -r  > 'output.txt'

head output.txt | awk '{print $2, $3}' > topips.txt
awk '!$2{next}1' topips.txt > cleanlist.txt

#head output.txt | awk '{print $1}' 



echo 'Possible Brute Force Attackers: '
#cat cleanlist.txt
#Create a count
dev=1
#Sep  6, 2019 14:46:30.003887000 EDT
while read -r key value;do
    #Pull the epoch time from the top hit ips in the pcap
    tshark -r "$in_pcap" -T fields -e frame.time_epoch 'ip.src== '$key' and tcp.dstport== '$value'' | sort -n > $key.$value.txt
    #Grab the first and last time counts
    hd=$(head -n1 $key.$value.txt)
    tl=$(tail -n1 $key.$value.txt)
    (echo -n 'IP address ' && head -n $dev cleanlist.txt | tail -n +$dev | awk '{print $1}' | tr "\n" " " && echo -n 'hit port number ' && head -n $dev cleanlist.txt | tail -n +$dev | awk '{print $2}' | tr "\n" " " &&  head -n $dev output.txt | tail -n +$dev | awk '{print $1}' | tr "\n" " " && echo -n 'times in ' && awk '{print $1-$2}' <<< "$tl $hd" | tr "\n" " " && echo 'seconds')
    dev=$((dev+1))
    rm $key.$value.txt
done < cleanlist.txt


rm output.txt
rm topips.txt
rm cleanlist.txt
#declare -A dict

#echo ${dict[@]}
#tshark -n -T fields 'ip.src== -e' frame.time

#for i in $(cut -d, -f2 topips.txt);do 
   #echo $i;  done




#tshark -r "$in_pcap" -T fields -e frame.time
#rm output.cvs
