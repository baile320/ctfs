# Solutions
**THERE ARE SPOILERS AHEAD.**

These are my full solutions to the [bandit](https://overthewire.org/wargames/bandit/) ctf wargame. This is an "introductory" wargame so most of the challenges are fairly easy if you're familiar with common linux commands. If you're not familiar with the linux commands already, this ctf can be challenging but doable if you read the man pages and follow the hints. **Don't be discouraged!** You're learning a new language.

There are also a lot of good resources online for this war game in case you get stuck. My solutions will be fairly terse, although I will try to point out interesting things I find.


## Level 0
Log in with the username and password `bandit0` given to us by the prompt.

## Level 0 to Level 1
The hint tells us to look in the `readme` file.

```bash
cat /home/bandit0/readme
```

password: `boJ9jbbUNNfktd78OOpsqOltutMc3MY1`

## Level 1 to Level 2
The hint tells us that the password is in a file named `-`.

This is a weird filename and if we just use cat we may run into some issues.

Get the password by using:
```bash
cat /home/bandit1/-
```
password: `CV1DtqXWVFXTvM2F0k09SHz0YwRINYA9`

## Level 2 to Level 3
There are spaces in this file name, so we need to escape them with `\` if we're going to use `cat`.

```bash
cat ./spaces\ in\ this\ filename
```
password: `UmHadQclWmgdLOKQ3YNgjWxGoRMb5luK`
## Level 3 to Level 4
We can explore the various directories using `ls -a` to display all of the files (even ones that are 'hidden', prefixed by a `.`). To find the password:

```bash
cat ~/inhere/.hidden
```
password: `pIwrPrtPN36QITSp3EQaw936yaFoFgAB`
## Level 4 to Level 5
The hint tells us to find a human readable file. We can use the file command to display file types in the given directory.

```bash
cd ~/inhere
file ./* # notice that ./-file07 has ASCII text, which is human readable
cat ./-file07
```

password: `koReBOKuIDDepwhWk7jZC0RTdopnAYKh`

## Level 5 to Level 6
The hint that it is human readable and has 1033 bytes is very helpful, because we can use grep to look for files with 1033 bytes.

```bash
cd inhere/
ls -Ralt | grep 1033 -B 10 # shows us that .file2 is the correct file and is in ./maybehere07
cat ./maybehere07/.file2
```
The `-Ralt` command does the following:
1) List files/directories recursively
2) List all (including hidden)
3) Use a long listing format (shows full paths)
4) Sort by time, newest first

For the `grep` command, the arguments:
1) Look for the string `1033` in the output
2) `-B 10` gives us context by showing us the previous 10 lines from the match.

password = `DXjZPULLxYr17uwoI01bNLQbtFemEgo7`

## Level 6 to Level 7
All we know is that the file is somewhere on the server, who the file is owned by, and how many bytes it has. Luckily, we can pipe several greps together to form an effective filter on every file on the server.

```bash
cd / # root directory from which we'll search everything
ls -Ralt 2>/dev/null | grep bandit7 | grep bandit6 | grep 33 # shows us the filename is "bandit7.password" and suppresses errors
find . -name bandit7.password 2>/dev/null # gives us the actual file path and suppresses annoying errors
cat ./var/lib/dpkg/info/bandit7.password # gives us the password
```

I already explained the `-Ralt` flag, but the `2>/dev/null` is new. Basically, this allows us to direct all of the error messages we get into `/dev/null`, which means we don't get them in our terminal display. Try removing that and seeing what the output looks like. Messy.

alternatively, using some other fancy tricks (`xargs`), the last two commands can be collapsed into one:

```bash
find . -name bandit7.password 2>/dev/null | xargs cat
```

password = `HKBPTKQnIay4Fw76bEy8PVxKEDQRKTzs`

## Level 7 to level 8
Pretty simple one, prompt tells us to look for "millionth"

```bash
cat data.txt | grep millionth
```

password: `cvX2JJa4CFALtqS87jk27qwqGhBM9plV`

## Level 8 to Level 9
The (probably) better way
```bash
sort data.txt | uniq -u
```
The `-u` flag outputs the unique lines of the file after we sort it. We have to sort first because `uniq` works on adjacent lines (see `man uniq`)

or the hacky way:

```bash
sort data.txt | uniq -c | grep "1 "
```
which sorts the file, counts the occurrences, and finds which output lines contain `"1 "` (one occurence)

password: `UsvVyFSfZZWbi6wgC7dAFyFuR6jQQUhR`

## Level 9 to Level 10
The hint suggests we look for likes of `=` characters, so let's just do that. You can get readable strings from a file with the `strings` command.

This, for example, lets us search binary (e.g. compiled code, executable) files that contain strings. If someone hard codes usernames/passwords in their compiled code, we could run strings on the binary and find them.


```bash
strings data.txt | grep === # note, there are lots of equals signs so we can try `grep ==` or `grep ====` etc.
```
password: `truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk`

## Level 10 to Level 11
Reading the man page for `base64` leads us to the following solution:

```bash
base64 -d data.txt
```

password: `IFukwKGsFW8MOq3IRFqrxE1hxTNEbUPR`

## Level 11 to Level 12
The `tr` command is kind of tricky, looking at some examples online helps. Luckily, the wikipedia article linked in the goal for this section almost gives the entire solution away.

```bash
cat data.txt | tr 'N-ZA-Mn-za-m' 'A-Za-z' # the wikipedia link in the OTW page tells us how to encrypt. decryption is just going backwards, so we switch the positions of the translation strings.
```
password: `5Te8Y4drgCRfCx8ugdwuEX8KFC6k2EUu`

## Level 12 to Level 13
This one is kind of long and boring. Lots of unzipping and file renaming. I'm just going to paste my output (sorry if a step is missed, but the basic idea between each step is very similar).

```bash
bandit12@bandit:~$ mkdir /tmp/<somedir>
bandit12@bandit:~$ cp data.txt /tmp/<somedir>/data.txt
bandit12@bandit:~$ cd /tmp/<somedir>/
bandit12@bandit:/tmp/<somedir>$ xxd -r data.txt > data
bandit12@bandit:/tmp/<somedir>$ file data # tells us it was gzipped and named data2
bandit12@bandit:/tmp/<somedir>$ mv data2.bin data.gz
bandit12@bandit:/tmp/<somedir>$ gunzip data.gz
bandit12@bandit:/tmp/<somedir>$ file data # tells us it was bzip2 compressed
bandit12@bandit:/tmp/<somedir>$ bunzip2 data # extracts to data.out
bandit12@bandit:/tmp/<somedir>$ file data.out # tells us it was gzipped
bandit12@bandit:/tmp/<somedir>$ mv data.out data.gz
bandit12@bandit:/tmp/<somedir>$ gunzip data.gz
bandit12@bandit:/tmp/<somedir>$ file data # tells us it is a tar archive
bandit12@bandit:/tmp/<somedir>$ tar -xf data # extracts to data5.bin
bandit12@bandit:/tmp/<somedir>$ file data5.bin # tells us it is a tar
bandit12@bandit:/tmp/<somedir>$ tar -xf data5.bin # extracts to data6.bin
bandit12@bandit:/tmp/<somedir>$ file data6.bin # tells us it is bzip2 compressed
bandit12@bandit:/tmp/<somedir>$ bunzip2 data6.bin # unzips to data6.bin.out
bandit12@bandit:/tmp/<somedir>$ file data6.bin.out # tells us it is a tar
bandit12@bandit:/tmp/<somedir>$ tar -xf data6.bin.out # unzips to data8
bandit12@bandit:/tmp/<somedir>$ file data8.bin # tells us it is gzip compressed
bandit12@bandit:/tmp/<somedir>$ mv data8.bin data8.gz
bandit12@bandit:/tmp/<somedir>$ gunzip data8.gz # unzips to data8
bandit12@bandit:/tmp/<somedir>$ cat data8 # contains the password
```
password: `8ZjyCRiBWFYkneahHwxCv3wb2a1ORpYL`

## Level 13 to Level 14
Looking in the directory, we see `sshkey.private`. Reading the man page for `ssh` tells us about the `-i` flag which specifies an "identity file"

To get the password:
```bash
ssh -i sshkey.private bandit14@localhost # input the password for level 13 again
cat /etc/bandit_pass/bandit14
```
password: `4wcYUJFw0k0XLShlDzztnTBHiqxU3b3e`

## Level 14 to Level 15

```bash
telnet localhost 30000 # and then paste the bandit14 password again, and server will respond with the password

# NOTE: `nc localhost 30000` will work to connect as well
```

password: `BfMYroe26WYalil77FoDi9qh59eK5xNr`

## Level 15 to Level 16
This took some googling and man page reading on my part to figure out, because I though `s_client` was a command or something, I didn't realize immediately that I needed to use it as an argument to `openssl`

```bash
openssl s_client -host localhost -port 30001 # and then paste the bandit15 password again, and server will respond with the password
```
password: `cluFn7wTiGryunymYOu4RcffSxQluehd`

## Level 16 to Level 17

to find password:
1) Scan the port range: `nmap localhost -p 31000-32000`
2) use `openssl s_client -host localhost -port <port_from_nmap>` until you get the right combination...
it will output something like:
```
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvmOkuifmMg6HL2YPIOjon6iWfbp7c3jx34YkYWqUH57SUdyJ
imZzeyGC0gtZPGujUSxiJSWI/oTqexh+cAMTSMlOJf7+BrJObArnxd9Y7YT2bRPQ
Ja6Lzb558YW3FZl87ORiO+rW4LCDCNd2lUvLE/GL2GWyuKN0K5iCd5TbtJzEkQTu
DSt2mcNn4rhAL+JFr56o4T6z8WWAW18BR6yGrMq7Q/kALHYW3OekePQAzL0VUYbW
JGTi65CxbCnzc/w4+mqQyvmzpWtMAzJTzAzQxNbkR2MBGySxDLrjg0LWN6sK7wNX
x0YVztz/zbIkPjfkU1jHS+9EbVNj+D1XFOJuaQIDAQABAoIBABagpxpM1aoLWfvD
KHcj10nqcoBc4oE11aFYQwik7xfW+24pRNuDE6SFthOar69jp5RlLwD1NhPx3iBl
J9nOM8OJ0VToum43UOS8YxF8WwhXriYGnc1sskbwpXOUDc9uX4+UESzH22P29ovd
d8WErY0gPxun8pbJLmxkAtWNhpMvfe0050vk9TL5wqbu9AlbssgTcCXkMQnPw9nC
YNN6DDP2lbcBrvgT9YCNL6C+ZKufD52yOQ9qOkwFTEQpjtF4uNtJom+asvlpmS8A
vLY9r60wYSvmZhNqBUrj7lyCtXMIu1kkd4w7F77k+DjHoAXyxcUp1DGL51sOmama
+TOWWgECgYEA8JtPxP0GRJ+IQkX262jM3dEIkza8ky5moIwUqYdsx0NxHgRRhORT
8c8hAuRBb2G82so8vUHk/fur85OEfc9TncnCY2crpoqsghifKLxrLgtT+qDpfZnx
SatLdt8GfQ85yA7hnWWJ2MxF3NaeSDm75Lsm+tBbAiyc9P2jGRNtMSkCgYEAypHd
HCctNi/FwjulhttFx/rHYKhLidZDFYeiE/v45bN4yFm8x7R/b0iE7KaszX+Exdvt
SghaTdcG0Knyw1bpJVyusavPzpaJMjdJ6tcFhVAbAjm7enCIvGCSx+X3l5SiWg0A
R57hJglezIiVjv3aGwHwvlZvtszK6zV6oXFAu0ECgYAbjo46T4hyP5tJi93V5HDi
Ttiek7xRVxUl+iU7rWkGAXFpMLFteQEsRr7PJ/lemmEY5eTDAFMLy9FL2m9oQWCg
R8VdwSk8r9FGLS+9aKcV5PI/WEKlwgXinB3OhYimtiG2Cg5JCqIZFHxD6MjEGOiu
L8ktHMPvodBwNsSBULpG0QKBgBAplTfC1HOnWiMGOU3KPwYWt0O6CdTkmJOmL8Ni
blh9elyZ9FsGxsgtRBXRsqXuz7wtsQAgLHxbdLq/ZJQ7YfzOKU4ZxEnabvXnvWkU
YOdjHdSOoKvDQNWu6ucyLRAWFuISeXw9a/9p7ftpxm0TSgyvmfLF2MIAEwyzRqaM
77pBAoGAMmjmIJdjp+Ez8duyn3ieo36yrttF5NSsJLAbxFpdlc1gvtGCWW+9Cq0b
dxviW8+TFVEBl1O4f7HVm6EpTscdDxU+bCXWkfjuRb7Dy9GOtt9JPsX8MBTakzh3
vBgsyi/sN3RqRBcGU40fOoZyfAMT8s1m/uYv52O6IgeuZ/ujbjY=
-----END RSA PRIVATE KEY-----
```
save this output in /tmp/<whatever>/lv16.key using your favorite method. I copied+pasted it using vim.

```bash
chmod 600 /tmp/graeme2/lv16.key # sets permissions so user can read/write but nobody else can read/write/execute
ssh -i /tmp/<whatever>/lv16.key bandit17@localhost
cat /etc/bandit_pass/bandit17
```
password: `xLYVMN9WE5zQ5vHacb0sZEVqbrp7nBTn`

## Level 17 to Level 18
to find password:
```bash
diff passwords.old passwords.new
```
output:
```
< <old_password>
---
> <new_password>
```
password: `kfBf3eYk5BPBRzwjqutbbfE887SVc5Yd`

## Level 18 to Level 19
To find the password:

```bash
ssh bandit18@bandit.labs.overthewire.org -p 2220 "cat readme"
```
Running a command over `ssh` means that a login shell won't be created (see `man ssh` and look for "login shell"), which (I think) means the .profile scripts, etc. that normally run on startup won't be executed. Since it is those scripts that are kicking us off, they are effectively bypassed. The command wil just output the password we're looking for.

password: `IueksS7Ubh8G3DCwVzrTd8rAVOwq3M5x`

## Level 19 to Level 20
to find the password:

```bash
./bandit20-do cat /etc/bandit_pass/bandit20
```
this tells `bandit20-do` to cat the file, and since it has the `setuid` (I found [this link](https://www.computerhope.com/jargon/s/setuid.htm) to be helpful) bit set appropriately, it will run `cat` as `bandit20` permissions even though we are only `bandit19`.

password: `GbKksEFF4yrVs6il55v6gwY5aVje5f0j`

## Level 20 to Level 21
This one was especially tricky for me, and I have a note to myself to do more reading. I did a lot of googling and got some hints to be able to complete this prompt.

to find the password:
first, read the tmux man page (or google) and figure out how to split panels and navigate panels.

helpful commands are: (must use ctrl+b to activate tmux shortcut mode) '%'', '"', <arrow keys>

1) in a first tmux panel:
```bash
echo "GbKksEFF4yrVs6il55v6gwY5aVje5f0j" | nc -l -p 60606` # sets up a listener that will echo last level's password
# NOTE: the port number is arbitrary but needs to be available on the system otherwise you cant open a listener
```
2) in another tmux panel:
```bash
./suconnect 60606 # connects to the listener in the other panel
```
you should now see the password output in the first tmux panel

NOTE/**EASY** ALTERNATIVE: if you want to avoid tmux you can use & like so:
```bash
nc -l -p 60606 -c 'echo "GbKksEFF4yrVs6il55v6gwY5aVje5f0j"' & # creates a background process
nc localhost 60606 # same terminal session
```

password: `gE269g2h3mw3pwgrj0Ha9Uoqen1c9DGr`

## Level 21 to Level 22
The hint tells us to look in /etc/cron.d/ and there is a file called cronjob_bandit22 so let's look there.

```bash
less /etc/cron.d/cronjob_bandit22 # tells us `/usr/bin/cronjob_bandit22.sh` is being run.
less /usr/bin/cronjob_bandit22.sh # tells us to look in /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv for the password
cat /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
```

password: `Yk7owGAcWjwMVRwrTesJEwB7WVOiILLI`

## Level 22 to Level 23
to find password:

The hint tells us to look in /etc/cron.d/ and there is a file called cronjob_bandit23 so let's look there.
```bash
`less /etc/cron.d/cronjob_bandit23` # tells us `/usr/bin/cronjob_bandit23.sh` is being run.
`less /usr/bin/cronjob_bandit23.sh` # Some interesting stuff, we can probably figure out what it does. Let's just run it though.
```

```bash
myname=bandit23 # change this to bandit23 because otherwise it will think we're bandit22
mytarget=$(echo I am user $myname | md5sum | cut -d ' ' -f 1) # does some fancy stuff to mutate the directory name
echo "Copying passwordfile /etc/bandit_pass/$myname to /tmp/$mytarget" # does an output that tells us where to look, tells us "Copying passwordfile /etc/bandit_pass/bandit23 to /tmp/8ca319486bfbbc3663ea0fbe81326349"
cat /tmp/$mytarget # tells us the password
```

password: `jc1udXuA1tiHqjIsL8yaapX5XIAI6i0n`

## Level 23 to Level 24
Following the hints again:

```bash
less /etc/cron.d/cronjob_bandit24 # tells us to look at /usr/bin/cronjob_bandit24.sh
less /usr/bin/cronjob_bandit24.sh # the hint tells us what this does, but basically it will run a script we create in /var/spool/bandit24
```

Let's create the following:

```bash
mkdir /tmp/graeme24_test/
touch /tmp/graeme24_test/pass24.txt
chmod 777 /tmp/graeme24_test/pass24.txt
echo "cat /etc/bandit_pass/bandit24 > /tmp/graeme24_test/pass24.txt" > /var/spool/bandit24/bandit24.sh
chmod 777 /var/spool/bandit24/bandit24.sh
```

Then we need to wait a minute for the cron job to run, and we can collect our password: `UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ`

## Level 24 to Level 25
Time to write our first fully-fledged shell script. I had to do a little googling and reading to come up with this. First, I had four deeply nested four loops to output the pin (i.e. for i, for j, for k, for l... echo <password> $i$j$k$l. Pretty dumb.). Then, I found out you can pipe the results from a `for` loop in to `nc`. So I got the following:

```bash
for i in {0000..9999}; do
   echo "UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ $i"
done | nc localhost 30002
```

This outputs a TON of garbage though, so a better solution would be
```bash
for i in {0000..9999}; do
   echo "UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ $i"
done | nc localhost 30002 | grep -v Wrong
```
The `-v` flag on `grep` is pretty awesome, and I learned about it on this exercise. In our example, it returns everything that DOESN'T match `Wrong`. Cool.

password: `uNG9O58gUE7snukf3bvZ0rxhtnjzSGzG`

## Level 25 to Level 26
To be honest, I really struggled with this one. Follow [this very helpful guide](https://medium.com/@coturnix97/overthewires-bandit-25-26-shell-355d78fd2f4d)... in fact, once I got into vim, the password for bandit26 wasn't even displayed so I'm not sure if there's a bug on my side or if something else is wrong?

Despite struggling with this one, there's a TON to learn while reading through the excellent write-up I linked about. I learned a lot about `vim` and `more` I had no idea about! Wow, they're powerful programs!

password: `5czgV9L3Xx8JPOyRbXh6lQbmIOWvPT6Z`

## Level 26 to Level 27
Back to familiar territory!

```bash
ls -a # note there's a bandit27-do binary! we know what to do now!
./bandit27-do cat /etc/bandit_pass/bandit27
```

password: `3ba3118a22e93127a4ed485be72ef5ea`

## Level 27 to Level 28
Looks like we'll need to use git to find this password.

To find the password:
```bash
mkdir /tmp/<somedir>
git clone ssh://bandit27-git@localhost/home/bandit27-git/repo /tmp/<somedir>
ls -hartl /tmp/<somedir> # shows us a README
cat /tmp/<somedir>/README
```
password: `0ef186ac70e04ea33b4c1853d2526fa2`
# Things to drill down on
1) From 20 -> 21: why can I `echo <stuff> | nc -l -p 60606`? Does it effectively run `nc -l -p 60606 -e "echo <stuff>"`? What else can I pipe to nc? nc also takes a -c/-e flag where it can accept a script or binary to run when connections are made.
2)