#!/bin/sh
# https://overthewire.org/wargames/bandit/bandit18.html

# to find password:
# `diff passwords.old passwords.new`
# output:
# < old_password
# ---
# > new_password
# so, new password is: kfBf3eYk5BPBRzwjqutbbfE887SVc5Yd

ssh bandit18@bandit.labs.overthewire.org -p 2220
