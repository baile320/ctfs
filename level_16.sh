#!/bin/sh
# https://overthewire.org/wargames/bandit/bandit16.html

# password = cluFn7wTiGryunymYOu4RcffSxQluehd, found by
# `openssl s_client -host localhost -port 30001` # and then paste the bandit15 password again, and server will respond with the above

ssh bandit16@bandit.labs.overthewire.org -p 2220
