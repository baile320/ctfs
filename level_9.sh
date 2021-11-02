#!/bin/sh

# https://overthewire.org/wargames/bandit/bandit9.html

# password = UsvVyFSfZZWbi6wgC7dAFyFuR6jQQUhR, found by
# `sort data.txt | uniq -u` or `sort data.txt | uniq -c | grep "1 "`

ssh bandit9@bandit.labs.overthewire.org -p 2220
