#!/bin/sh
# https://overthewire.org/wargames/bandit/bandit21.html

# to find password:
# first, read the tmux man page (or google) and figure out how to split panels and navigate panels.
# helpful commands are: (must use ctrl+b to activate tmux shortcut mode) '%'', '"', <arrow keys>
# in one tmux panel (1): `echo "GbKksEFF4yrVs6il55v6gwY5aVje5f0j" | nc -l -p 60606` # password from previous level
# in another tmux panel (2) `./suconnect 60606` # port number is arbitrary but needs to be available
# you should now see the password output in tmux panel (1)
# password: gE269g2h3mw3pwgrj0Ha9Uoqen1c9DGr

# NOTE/ALTERNATIVE: if you want to avoid tmux you can use & like so:
# `nc -l -p 60606 -c 'echo "GbKksEFF4yrVs6il55v6gwY5aVje5f0j"' &` # creates a background process
# `nc localhost 60606` # same terminal session

ssh bandit21@bandit.labs.overthewire.org -p 2220
