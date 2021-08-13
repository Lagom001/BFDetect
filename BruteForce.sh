#!/bin/bash

echo 'What file would you like to open?'
read in_pcap
#Pull top src ip and dst port and calculate amount per ip/port
tshark -r "$in_pcap" -T fields -e ip.src -e tcp.dstport | sort | uniq -c | sort -k 1 -n -r  > 'output.txt'

head output.txt | awk '{print $2, $3}' > topips.txt
awk '!$2{next}1' topips.txt > cleanlist.txt

echo 'Possible Brute Force Attackers: '
cat cleanlist.txt
#Sep  6, 2019 14:46:30.003887000 EDT
while read -r key value;do
    tshark -r "$in_pcap" -T fields -e frame.time_epoch 'ip.src== '$key' and tcp.dstport== '$value'' | sort -n > $key.$value.txt
    #date -d $key.$value.txt '+%b +%d, +%Y +%T.+%N +%Z' > mean.txt 
    hd= head -n1 $key.$value.txt
    tl= tail -n1 $key.$value.txt
    echo $tl - $hd
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
