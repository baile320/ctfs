# Solutions
**THERE ARE SPOILERS AHEAD.**

These are my full solutions to the [bandit](https://overthewire.org/wargames/bandit/) ctf wargame.

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
Found by:
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
# Things to drill down on
1) From 20 -> 21: why can I `echo <stuff> | nc -l -p 60606`? Does it effectively run `nc -l -p 60606 -e "echo <stuff>"`? What else can I pipe to nc? nc also takes a -c/-e flag where it can accept a script or binary to run when connections are made.
2)