from scraper import OshoScraper
import logging

# Set logging to see details
logging.basicConfig(level=logging.INFO)

print("--- STARTING LOCAL TEST ---")
scraper = OshoScraper()

# Test one series: Agyat Ki Aur
# Using the verified slug found in Next.js data
series_slug = "010-agyat-ki-aur-1-7"
series_url = f"https://oshoworld.com/{series_slug}"
series_data = {
    "title": "Agyat Ki Aur (अज्ञात की ओर)",
    "slug": series_slug
}

scraper.scrape_series_details(series_url, series_slug, series_data)

print("--- TEST COMPLETED ---")
