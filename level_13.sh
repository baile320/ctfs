#!/bin/sh
# https://overthewire.org/wargames/bandit/bandit13.html

# password = 8ZjyCRiBWFYkneahHwxCv3wb2a1ORpYL, found by

# bandit12@bandit:~$ mkdir /tmp/<somedir>
# bandit12@bandit:~$ cp data.txt /tmp/<somedir>/data.txt
# bandit12@bandit:~$ cd /tmp/<somedir>/
# bandit12@bandit:/tmp/<somedir>$ xxd -r data.txt > data
# bandit12@bandit:/tmp/<somedir>$ file data # tells us it was gzipped and named data2
# bandit12@bandit:/tmp/<somedir>$ mv data2.bin data.gz
# bandit12@bandit:/tmp/<somedir>$ gunzip data.gz
# bandit12@bandit:/tmp/<somedir>$ file data # tells us it was bzip2 compressed
# bandit12@bandit:/tmp/<somedir>$ bunzip2 data # extracts to data.out
# bandit12@bandit:/tmp/<somedir>$ file data.out # tells us it was gzipped
# bandit12@bandit:/tmp/<somedir>$ mv data.out data.gz
# bandit12@bandit:/tmp/<somedir>$ gunzip data.gz
# bandit12@bandit:/tmp/<somedir>$ file data # tells us it is a tar archive
# bandit12@bandit:/tmp/<somedir>$ tar -xf data # extracts to data5.bin
# bandit12@bandit:/tmp/<somedir>$ file data5.bin # tells us it is a tar
# bandit12@bandit:/tmp/<somedir>$ tar -xf data5.bin # extracts to data6.bin
# bandit12@bandit:/tmp/<somedir>$ file data6.bin # tells us it is bzip2 compressed
# bandit12@bandit:/tmp/<somedir>$ bunzip2 data6.bin # unzips to data6.bin.out
# bandit12@bandit:/tmp/<somedir>$ file data6.bin.out # tells us it is a tar
# bandit12@bandit:/tmp/<somedir>$ tar -xf data6.bin.out # unzips to data8
# bandit12@bandit:/tmp/<somedir>$ file data8.bin # tells us it is gzip compressed
# bandit12@bandit:/tmp/<somedir>$ mv data8.bin data8.gz
# bandit12@bandit:/tmp/<somedir>$ gunzip data8.gz # unzips to data8
# bandit12@bandit:/tmp/<somedir>$ cat data8 # contains the password

ssh bandit13@bandit.labs.overthewire.org -p 2220
