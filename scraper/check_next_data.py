import requests
from bs4 import BeautifulSoup
import json

url = "https://oshoworld.com/010-agyat-ki-aur-1-7"
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"}

response = requests.get(url, headers=headers)
soup = BeautifulSoup(response.text, 'lxml')
script = soup.find("script", id="__NEXT_DATA__")

if script:
    data = json.loads(script.string)
    list_data = data['props']['pageProps']['data']['pageData']['listData']
    if list_data:
        print(json.dumps(list_data[0], indent=2))
    else:
        print("listData is empty")
else:
    print("No __NEXT_DATA__ found")
