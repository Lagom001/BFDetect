#!/bin/bash

echo "What file would you like to open?"
read in_pcap

tshark -r "$in_pcap" -T fields -e ip.src -e tcp.dstport | sort | uniq -c | sort -k 1 -n -r  > "output.txt"
#tshark -r "$in_pcap" -T fields -e ip.dst -e tcp.dstport | sort | uniq -c | sort -k 1 -n -r  > "output2.cvs"

head output.txt | awk '{print $2, $3}' > topips.txt
awk '!$2{next}1' topips.txt > cleanlist.txt

echo "Possible Brute Force Attackers: "
cat cleanlist.txt

while read -r key value;do
    tshark -r "$in_pcap" -T fields -e frame.time 'ip.src== '$key' and tcp.dstport== '$value'' > $key.$value.txt
    Epoch_Time = date -f $key.$value.txt +%s | sort
    Difference = (head -n1 $Epoch_Time) - (tail -n1 $Epoch_Time)
    echo $Difference
    rm $key.$value.txt
done < cleanlist.txt
#declare -A dict

#echo ${dict[@]}
#tshark -n -T fields 'ip.src== -e' frame.time

#for i in $(cut -d, -f2 topips.txt);do 
   #echo $i;  done

rm output.txt
rm topips.txt
rm cleanlist.txt


#tshark -r "$in_pcap" -T fields -e frame.time
#rm output.cvs
