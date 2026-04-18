import os
import time
import requests
from bs4 import BeautifulSoup
from slugify import slugify
import firebase_admin
from firebase_admin import credentials, firestore
import logging

# Configure Logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Constants
HINDI_HOME = "https://oshoworld.com/audio-hindi-home"
ENGLISH_HOME = "https://oshoworld.com/audio-english-home"
USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

class OshoScraper:
    def __init__(self):
        self.db = self._init_firebase()
        self.session = requests.Session()
        self.session.headers.update({"User-Agent": USER_AGENT})

    def _init_firebase(self):
        """Initializes Firebase Admin SDK."""
        # Use service account file if it exists, otherwise use default credentials (Cloud Run)
        sa_path = "serviceAccountKey.json"
        
        if os.path.exists(sa_path):
            cred = credentials.Certificate(sa_path)
            firebase_admin.initialize_app(cred)
        else:
            firebase_admin.initialize_app()
        
        return firestore.client()

    def scrape_catalog(self):
        """Main entry point to scrape Hindi and English catalogs."""
        logger.info("Starting catalog scrape...")
        
        # Scrape Hindi
        self.scrape_category(HINDI_HOME, "hi")
        
        # Scrape English
        self.scrape_category(ENGLISH_HOME, "en")
        
        logger.info("Scrape process completed.")

    def scrape_category(self, url, lang):
        """Scrapes all series from a category page."""
        logger.info(f"Scraping category: {url} ({lang})")
        response = self.session.get(url)
        if response.status_code != 200:
            logger.error(f"Failed to load category page: {url}")
            return

        soup = BeautifulSoup(response.text, 'lxml')
        
        # Grid items contain series info
        # Structure based on browser research: a.text-sky-700 for titles
        series_links = soup.select("a.text-sky-700")
        
        for link in series_links:
            title = link.get_text(strip=True)
            href = link.get('href')
            if not href:
                continue
                
            series_slug = slugify(title)
            series_id = series_slug # Using slug as Firestore ID
            
            # Find image in the parent/surrounding div
            parent_div = link.find_parent("div")
            img_tag = parent_div.find("img") if parent_div else None
            img_url = img_tag.get('src') if img_tag else ""
            
            logger.info(f"Found Series: {title} ({series_slug})")
            
            series_data = {
                "title": title,
                "slug": series_slug,
                "cover_image_url": img_url,
                "language": lang,
                "url": href
            }
            
            self.scrape_series_details(href, series_id, series_data)
            
            # Small delay to be polite
            time.sleep(1)

    def scrape_series_details(self, series_url, series_id, series_data):
        """Scrapes individual tracks from a series page."""
        logger.info(f"  Scraping tracks for: {series_data['title']}")
        response = self.session.get(series_url)
        if response.status_code != 200:
            logger.error(f"  Failed to load series page: {series_url}")
            return

        soup = BeautifulSoup(response.text, 'lxml')
        
        # Track titles are usually a.text-sky-800
        # MP3 links are a[href$=".mp3"]
        tracks = []
        track_elements = soup.select("a.text-sky-800")
        mp3_elements = soup.select('a[href$=".mp3"]')
        
        # Note: Track title and MP3 link count might differ if page structure is complex
        # We'll align them by iterating over MP3 links as they are the source of truth
        
        batch = self.db.batch()
        series_ref = self.db.collection("series").document(series_id)
        
        track_count = 0
        for i, mp3_link in enumerate(mp3_elements):
            mp3_url = mp3_link.get("href")
            # Try to get title from preceding text-sky-800 or the link itself
            title = mp3_link.get_text(strip=True) or f"Discourse {i+1}"
            
            # Verify URL
            is_broken = self.check_url_broken(mp3_url)
            
            track_id = str(i + 1).zfill(3)
            track_data = {
                "track_number": i + 1,
                "title": title,
                "audio_url": mp3_url,
                "is_broken": is_broken,
                "url_last_verified": firestore.SERVER_TIMESTAMP,
                "has_transcript": False
            }
            
            discourse_ref = series_ref.collection("discourses").document(track_id)
            batch.set(discourse_ref, track_data)
            track_count += 1

        # Update series metadata
        series_data["discourse_count"] = track_count
        series_data["last_updated"] = firestore.SERVER_TIMESTAMP
        batch.set(series_ref, series_data, merge=True)
        
        batch.commit()
        logger.info(f"  Successfully synced {track_count} tracks for {series_id}")

    def check_url_broken(self, url):
        """Performs a HEAD request to check if a URL is alive."""
        try:
            res = self.session.head(url, allow_redirects=True, timeout=5)
            return res.status_code >= 400
        except Exception:
            return True

if __name__ == "__main__":
    scraper = OshoScraper()
    scraper.scrape_catalog()
