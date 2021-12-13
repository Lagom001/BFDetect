# BFDetect
Uses tshark to filter pcap's in order to analyze if there has been a brute force attack. The program tells the user what the top IP addresses are, what ports they are hitting and in how many seconds.  This allows the user to focus on specific data when analyzing large pcaps.

---
## How to run BFDetect
After downloading the package, run the executable BruteForce.sh.  The program will then ask for a pcap file to open.  Be sure to input the absolute path of the file.

The program will then output the top potential malicious IPs. 