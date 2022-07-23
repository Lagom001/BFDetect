#!/bin/bash

if [ $# -eq 1 ] 
then 
    IFS= read -r <"$1"
    #Pull top src ip and dst port and calculate amount per ip/port
    tshark -r "$1" -T fields -e ip.src -e tcp.dstport | sort | uniq -c | sort -k 1 -n -r  > 'output.txt'

    #Grab only the IP and port, not the count
    head output.txt | awk '{print $2, $3}' > topips.txt
    #Clean up columns that are empty
    awk '!$2{next}1' topips.txt > cleanlist.txt

    echo 'Possible Brute Force Attackers: '

    #Create a count
    dev=1

    while read -r key value;do
        #Pull the epoch time from the top hit ips in the pcap
        tshark -r "$1" -T fields -e frame.time_epoch 'ip.src== '$key' and tcp.dstport== '$value'' | sort -n > $key.$value.txt
        #Grab the first and last time counts
        hd=$(head -n1 $key.$value.txt)
        tl=$(tail -n1 $key.$value.txt)
        #Print the dialogue of ip, port, and subtraction of time 
        (echo -n 'IP address ' && head -n $dev cleanlist.txt | tail -n +$dev | awk '{print $1}' | tr "\n" " " && echo -n 'hit port number ' && head -n $dev cleanlist.txt | tail -n +$dev | awk '{print $2}' | tr "\n" " " &&  head -n $dev output.txt | tail -n +$dev | awk '{print $1}' | tr "\n" " " && echo -n 'times in ' && awk '{print $1-$2}' <<< "$tl $hd" | tr "\n" " " && echo 'seconds')
        #Increase count
        dev=$((dev+1))
        rm $key.$value.txt
    done < cleanlist.txt

    #Remove files created
    rm output.txt
    rm topips.txt
    rm cleanlist.txt
else     
    echo "What file would you like to open?"     
    read in_pcap


    #Pull top src ip and dst port and calculate amount per ip/port
    tshark -r "$in_pcap" -T fields -e ip.src -e tcp.dstport | sort | uniq -c | sort -k 1 -n -r  > 'output.txt'

    #Grab only the IP and port, not the count
    head output.txt | awk '{print $2, $3}' > topips.txt
    #Clean up columns that are empty
    awk '!$2{next}1' topips.txt > cleanlist.txt

    echo 'Possible Brute Force Attackers: '

    #Create a count
    dev=1

    while read -r key value;do
        #Pull the epoch time from the top hit ips in the pcap
        tshark -r "$in_pcap" -T fields -e frame.time_epoch 'ip.src== '$key' and tcp.dstport== '$value'' | sort -n > $key.$value.txt
        #Grab the first and last time counts
        hd=$(head -n1 $key.$value.txt)
        tl=$(tail -n1 $key.$value.txt)
        declare -i amount=$(head -n $dev output.txt | tail -n +$dev | awk '{print $1}')
        #declare -i seconds=$( awk '{print $1-$2}' <<< "$tl $hd" )
        #echo $seconds
        #echo $amount
        #create threshhold
        if [ "$amount" -ge 50 ]
        then
        #Print the dialogue of ip, port, and subtraction of time 
            (echo -n 'IP address ' && head -n $dev cleanlist.txt | tail -n +$dev | awk '{print $1}' | tr "\n" " " && echo -n 'hit port number ' && head -n $dev cleanlist.txt | tail -n +$dev | awk '{print $2}' | tr "\n" " " &&  head -n $dev output.txt | tail -n +$dev | awk '{print $1}' | tr "\n" " " && echo -n 'times in ' && awk '{print $1-$2}' <<< "$tl $hd" | tr "\n" " " && echo 'seconds')
            #Increase count
            dev=$((dev+1))
            rm $key.$value.txt
        else
            dev=$((dev+1))
            rm $key.$value.txt
        fi
    done < cleanlist.txt

    #Remove files created
    rm output.txt
    rm topips.txt
    rm cleanlist.txt
fi