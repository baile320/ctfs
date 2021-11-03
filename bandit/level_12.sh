#!/bin/sh

# https://overthewire.org/wargames/bandit/bandit12.html

# password = 5Te8Y4drgCRfCx8ugdwuEX8KFC6k2EUu, found by
# `cat data.txt | tr 'N-ZA-Mn-za-m' 'A-Za-z'` # this wikipedia link in the OTW page helps

ssh bandit12@bandit.labs.overthewire.org -p 2220
