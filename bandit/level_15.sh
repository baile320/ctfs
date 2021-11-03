#!/bin/sh
# https://overthewire.org/wargames/bandit/bandit15.html

# password = BfMYroe26WYalil77FoDi9qh59eK5xNr, found by
# `telnet localhost 30000` # and then paste the bandit14 password again, and server will respond with the above
# NOTE: `nc localhost 30000` will work as well

ssh bandit15@bandit.labs.overthewire.org -p 2220
