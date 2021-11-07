# Krypton
These are my solutions to the [krypton ctf](https://overthewire.org/wargames/krypton/krypton0.html). Since these are solutions, there are obviously spoilers. Additionally, they may be rather terse.

## Level 0 to Level 1

According to the hint, we need to decrypt the following from base64: `S1JZUFRPTklTR1JFQVQ=`. We do this as follows:

```bash
echo S1JZUFRPTklTR1JFQVQ= > file.txt
base64 -d file.txt # outputs KRYPTONISGREAT
rm file.txt
```

password: `KRYPTONISGREAT`

so now we `ssh krypton1@krypton.labs.overthewire.org -p 2231` and enter the password.

## Level 1 to Level 2
We're told the passwords are in `/krypton/krypton1`. If we look in that directory, there is the file with the encrypted password `krypton2` and a README. We are told that they follow a simple rotation.

```bash
cat /krypton/krypton1/krypton2 # outputs: YRIRY GJB CNFFJBEQ EBGGRA
```

We can use the `tr` function to translate the characters using regex. Theoretically, we could write one for every possible rotation (rotate 1 letter, 2 letters, etc). Before we go through all that work, I have a hunch we should check the most common rotation: rot13 (aka the caesar cipher). We use `tr` to translate that as follows:

```bash
cat /krypton/krypton1/krypton2 | tr '[a-z][A-Z]' '[n-za-m][N-ZA-M]'
```

Lucky guess! That outputs: `LEVEL TWO PASSWORD ROTTEN`.

## Level 2 to Level 3
There's lots more stuff in `/krypton/krypton2/` this time.

The readme gives us several hints

```bash
mktemp -d # this outputs a directory which we should shift to in the next command
cd /tmp/tmp.szPPV2wUhq # directory from previous command
ln -s /krypton/krypton2/keyfile.dat
chmod 777 .
/krypton/krypton2/encrypt /etc/issue # this encrypts /etc/issue and puts it in a file called ciphertext in the current directory
```

We know this is a standard, constant shifted ciphertext because the `README` told us that. Therefore, to be really clever, we only need to translate the character `a` and see what it gets shifted to, and then we know the entire shift. Just for sanity, I'll translate the entire alphabet.

```bash
echo 'abcdefghijklmnopqrstuvwxyz' > file.txt
/krypton/krypton2/encrypt file.txt
cat ciphertext # outputs: MNOPQRSTUVWXYZABCDEFGHIJKL
```

So, we know 'a' -> 'M', 'b' -> 'N' ... etc. If you could count and that's a 12 letter rotation (plus a case swap). We can use a similar trick to the last solution to translate the password now.

```bash
cat /krypton/krypton2/krypton3 | tr '[M-ZA-L][m-za-l]' '[A-Za-z]' # outputs CAESARISEASY
```

## Level 3 to Level 4
Idea: since we have multiple files, maybe we can use frequency analysis to identify what 'e' (or another common letter) is mapped to, and since these are (presumably?) another rotation cipher, we can figure out the key mapping