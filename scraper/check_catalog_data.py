import requests
from bs4 import BeautifulSoup
import json

url = "https://oshoworld.com/audio-series-home-hindi"
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"}

response = requests.get(url, headers=headers)
soup = BeautifulSoup(response.text, 'lxml')
script = soup.find("script", id="__NEXT_DATA__")

if script:
    data = json.loads(script.string)
    page_props = data.get('props', {}).get('pageProps', {})
    
    if 'data' in page_props:
        inner_data = page_props['data']
        if 'pageData' in inner_data:
            page_data = inner_data['pageData']
            print(f"Keys in pageData: {list(page_data.keys())}")
            # Let's print the whole pageData to be sure, or at least the first few levels
            print(json.dumps(page_data, indent=2)[:5000])
else:
    print("No __NEXT_DATA__ found")
