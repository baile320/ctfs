#!/bin/sh
# https://overthewire.org/wargames/bandit/bandit22.html

# to find password:

# hint tells us to look in /etc/cron.d/ and there is a file called cronjob_bandit22 so let's look there.
# `less /etc/cron.d/cronjob_bandit22` # tells us `/usr/bin/cronjob_bandit22.sh` is being run.
# `less /usr/bin/cronjob_bandit22.sh` # tells us to look in /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv for the password
# `cat /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv`
# password: Yk7owGAcWjwMVRwrTesJEwB7WVOiILLI

ssh bandit22@bandit.labs.overthewire.org -p 2220
