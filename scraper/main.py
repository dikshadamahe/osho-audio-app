from flask import Flask, jsonify
from scraper import OshoScraper
import threading
import os

app = Flask(__name__)
scraper = OshoScraper()

@app.route('/')
def health():
    return jsonify({"status": "healthy", "service": "osho-scraper"})

@app.route('/run')
def run_scraper():
    # Run in background to avoid timeout
    thread = threading.Thread(target=scraper.scrape_catalog, args=("https://oshoworld.com/audio-series-home-hindi",))
    thread.start()
    return jsonify({"message": "Scraper started in background"})

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)
