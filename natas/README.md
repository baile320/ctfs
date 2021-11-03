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
There is an img loaded from `/files/pixel.png`. I guess we should see what else is in /files/?

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

