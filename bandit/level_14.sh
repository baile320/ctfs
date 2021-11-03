#!/bin/sh
# https://overthewire.org/wargames/bandit/bandit14.html

# password = 4wcYUJFw0k0XLShlDzztnTBHiqxU3b3e, found by
# `ssh -i sshkey.private bandit14@localhost` # input the password for level 13 again
# `cat /etc/bandit_pass/bandit14`
ssh bandit14@bandit.labs.overthewire.org -p 2220
