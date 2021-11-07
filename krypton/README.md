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
