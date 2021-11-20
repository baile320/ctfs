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
My original thought was to do [frequency analysis](https://en.wikipedia.org/wiki/Frequency_analysis) to find the most common letters in the "foundX" files. In English, "E" is most common, followed by "T", "A", etc. So there's a good chance the most common letter in "foundX" are also the most common letters in English, and then we can use that mapping to translate the password.

```bash
sed 's/./&\n/g' found1 found2 found3 | sort | uniq -ic # counts the letters in the file. found here: https://askubuntu.com/questions/593383/how-to-count-occurrences-of-each-character
```

Looking through the output, `S` has 456 occurrences. That's a good candidate for the mapping of `E`. Next is `Q` with 340.

I'm really curious if there's a good way to solve this besides brute force. I even tried several tools like JCrypTool and some online sites to make this easier but just got a huge mess.

[This site](https://quipqiup.com/) seems to give us exactly the answer we want. Upload all of the files (see [my file here](./krypton3_texts.txt)). The answer it gives is: `the level four password is brute` (actually, the password is `BRUTE`).

## Level 4 to Level 5


We're given the following hint:

```
Frequency analysis will still work, but you need to analyse it
by "keylength".  Analysis of cipher text at position 1, 6, 12, etc
should reveal the 1st letter of the key, in this case.  Treat this as
6 different mono-alphabetic ciphers...

Persistence and some good guesses are the key!
```

I'm gonna be honest, I'm not super into guessing for these CTF challenges. [dcode](https://www.dcode.fr/vigenere-cipher) has a vignere cipher cracker that we can use. Input the text from one of the password files, input the key length of 6, and it will spit out the decoder key: `FREKEY`.

Inputting the password file and decoding

password: `CLEARTEXT`.

## Level 5 to Level 6
We're just gonna use [dcode](https://www.dcode.fr/vigenere-cipher) again on this one. Input one of the texts into the input box. Toggle 'VIGENERE CRYPTANALYSIS (KASISKI'S TEST)' and click 'decrypt'. This suggests the likely keylengths are 3, 6, or 9. Toggle 'KNOWING THE KEY-LENGTH/SIZE, NUMBER OF LETTERS:' and enter 3, 6, 9 in succession. Basically, I scrolled through the various 'decodings' until I found one that was entirely english. The key was `KEYLENGTH`.

password: `RANDOM`

## Level 6 to Level 7
