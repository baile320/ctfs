# Solutions
**THERE ARE SPOILERS AHEAD.**

These are my full solutions to the [leviathan](https://overthewire.org/wargames/leviathan/) ctf wargame. This is an "introductory" wargame so most of the challenges are fairly easy if you're familiar with common linux commands. If you're not familiar with the linux commands already, this ctf can be challenging but doable if you read the man pages and follow the hints. **Don't be discouraged!** You're learning a new language.

There are also a lot of good resources online for this war game in case you get stuck. My solutions will be fairly terse, although I will try to point out interesting things I find.


## Level 0
Log in with the username and password `leviathan0` given to us by the prompt.

## Level 0 to Level 1
Taking a look around on the server, this CTF seems to be structured similarly to the `bandit` other wargames that have passwords in `/etc/leviathan_pass/<password_file>`. Unfortunately, we can't read the `/etc/leviathan_pass/leviathan1` file.

Looking at the current directory, we see the following:

```
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