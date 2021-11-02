#!/bin/sh

# https://overthewire.org/wargames/bandit/bandit7.html

# password = HKBPTKQnIay4Fw76bEy8PVxKEDQRKTzs, found by
# `cd /`
# `ls -Ralt 2>/dev/null | grep bandit7 | grep bandit6 | grep 33` # shows us the filename is "bandit7.password" and suppresses errors
# `find . -name bandit7.password 2>/dev/null` # gives us the actual file path and suppresses annoying errors
# `cat ./var/lib/dpkg/info/bandit7.password` # gives us the password

# alternatively, `find . -name bandit7.password 2>/dev/null | xargs cat`
ssh bandit7@bandit.labs.overthewire.org -p 2220
