# Solutions
**THERE ARE SPOILERS AHEAD.**

These are my full solutions to the [natas](http://overthewire.org/wargames/natas/) ctf wargame.

## Level 0 to Level 1
Log in to level 0 with the following:

```
Username: natas0
Password: natas0
URL:      http://natas0.natas.labs.overthewire.org
```

password for level 1 is found in an HTML comment, so inspect the page source.

password: `gtVrDuiDfck831PqWsLEZy5gyDz1clto`

## Level 1 to Level 2
Same as previous level. Right clicking has been disabled so use the browser toolbar (or use a hotkey if you know them, mine is ctrl+shift+I) to open the developer tools to read the source.

password: `ZluruAthQk7Q2MqmDeTiUij2ZvWy2mBi`

## Level 2 to Level 3
There is an img loaded from `/files/pixel.png`. I guess we should see what else is in `/files/`?

Visiting `http://natas2.natas.labs.overthewire.org/files/` shows us there is a `users.txt` which has the password we're looking for.

password: `sJIJNW6ucpu6HPZ1ZAchaDtwd7oGrD14`

## Level 3 to Level 4
If google won't find it, it could be related to having a `robots.txt` file. Let's check for that.

Surprise! We get the following:

```
User-agent: *
Disallow: /s3cr3t/
```

If you check the `/s3cr3t/` endpoint you'll see another `users.txt` with the next password.

password: `Z9tkRkWmpt9Qr7XrR5jWRkgOU901swEZ`

## Level 4 to Level 5
Apparently (I found this through googling, because I was pretty sure I knew what needed to be done after playing around on the page) we should use Burp or some other software to allow us to "spoof" our request.

Basically, we want natas4 to _think_ we're coming from natas5, even if we aren't.

In Burp, change the

`Referer: http://natas5.natas.labs.overthewire.org/`

and continue to get the password: `iX6IOfmpN7AYOQGPwtn3fXpbaJVJcHfq`

## Level 5 to Level 6
In Burp, there's a suspicious `Cookie: loggedin=0` item in the request. Change it to `loggedin=1` and continue.

password: `aGoY4q2Dc6MgDq4oL4YtoKtyAg9PeHa1`

## Level 6 to Level 7
Visit `https://natas6.natas.labs.overthewire.org/index-source.html` linked to from the "View sourcecode" hyperlink. I noticed in here that there's an `includes/secret.inc`... so I visited that file path in the url browser and saw the following:

```php
<?
$secret = "FOEIUWGHFEEUHOFUOIU";
?>
```

Back on the original webpage, if we submit the "secret" form using the `FOEIUWGHFEEUHOFUOIU` secret, we get the password: `7z3hEENjQtflzgnT29q7wAvMNfZdh0i9`

## Level 7 to Level 8

I thought this level would be related to query strings because the "Home" and "About" links go to places like `http://natas7.natas.labs.overthewire.org/index.php?page=about`... I didn't know what else to do so I opened the page source and saw the following hint:

`hint: password for webuser natas8 is in /etc/natas_webpass/natas8`

So, visit `http://natas7.natas.labs.overthewire.org/index.php?page=/etc/natas_webpass/natas8` and get the password.

password: `DBfUBfqQG69KvJvJ1iAbMoIpwSNQ9bWe`

## Level 8 to Level 9
Again, viewing the source code shows us something interesting:

```php
<?

$encodedSecret = "3d3d516343746d4d6d6c315669563362";

function encodeSecret($secret) {
    return bin2hex(strrev(base64_encode($secret)));
}

if(array_key_exists("submit", $_POST)) {
    if(encodeSecret($_POST['secret']) == $encodedSecret) {
    print "Access granted. The password for natas9 is <censored>";
    } else {
    print "Wrong secret";
    }
}
?>
```
So it looks like we need to de-encode `3d3d516343746d4d6d6c315669563362`, and we can do that by reversing the encoding procedure above. I've never used php but it seems pretty reasonable to guess we can do: `base64_decode(strrev(hex2bin("3d3d516343746d4d6d6c315669563362")))`... I had to find an online php interpreter because I don't have php installed. but I ran:

```php
<?php
	echo base64_decode(strrev(hex2bin("3d3d516343746d4d6d6c315669563362")))

?>
```

in one of the interpreters and got the secret to be `oubWYf2kBq`.

The password for the next level is: `W0mMhUcRRnG8dcghE4qvk3JA9lGt8nDl`.

## Level 9 to Level 10
I looked at the source code, and saw the following interesting line:

```php
if($key != "") {
    passthru("grep -i $key dictionary.txt");
}
```

Since this is grepping `$key`, I decided to be naughty and run `grep -i .* dictionary.txt` (i.e. I submitted the form with ".*"), which will dump the entirety of dictionary.txt. This didn't lead me anywhere.

Then I realized that we can essentially run arbitrary commands with an injection in the following way:

Submit the form with `; cat /etc/natas_webpass/natas10`. The semicolon terminates the grep command, and we know from a previous exercise where the password files are saved. Lo and behold, we get the password.

password: `nOpp1igQAkUzaI1GUUjzn1bFVj7xCNzu`

## Level 10 to Level 11