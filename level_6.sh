#!/bin/sh

# https://overthewire.org/wargames/bandit/bandit6.html

# password = DXjZPULLxYr17uwoI01bNLQbtFemEgo7, found by
# `cd inhere/`
# `ls -Ralt | grep 1033 -B 10` # shows us that .file2 is the correct file and is in ./maybehere07
# `cat ./maybehere07/.file2`

ssh bandit6@bandit.labs.overthewire.org -p 2220
