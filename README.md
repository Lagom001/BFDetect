# BFDetect
BFDetect uses tshark to filter pcap's in order to analyze if there has been a brute force attack. The program tells the user what the top IP addresses are, what ports they are hitting and in how many seconds.  This allows the user to focus on specific data when analyzing large pcaps.

---
## How to run BFDetect
After downloading the package, run the executable BruteForce.sh. The program will then ask for a pcap file to open.  Be sure to input the absolute path of the file.

The program will then output the top potential malicious IPs. 

<img width="639" alt="Screen Shot 2022-09-07 at 11 56 10 AM" src="https://user-images.githubusercontent.com/78869645/188957223-25c89fca-ecc9-45f5-a582-74a318408731.png">
