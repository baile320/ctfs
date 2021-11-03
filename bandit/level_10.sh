#!/bin/sh

# https://overthewire.org/wargames/bandit/bandit10.html

# password = truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk, found by
# `strings data.txt | grep ===` # note, there are lots of equals signs so you can try `grep ==` or `grep ====` etc.

ssh bandit10@bandit.labs.overthewire.org -p 2220
