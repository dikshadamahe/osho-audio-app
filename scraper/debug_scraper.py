import requests
from bs4 import BeautifulSoup

url = "https://oshoworld.com/agyat-ki-aur-01/"
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"}

response = requests.get(url, headers=headers)
print(f"Status Code: {response.status_code}")
print(f"Final URL: {response.url}")

soup = BeautifulSoup(response.text, 'lxml')
titles = soup.select("a.text-sky-800")
print(f"Found titles: {len(titles)}")

mp3s = soup.select('a[href$=".mp3"]')
print(f"Found MP3s: {len(mp3s)}")

# Save a snippet of the HTML to inspect
with open("debug_page.html", "w", encoding="utf-8") as f:
    f.write(response.text[:5000])
