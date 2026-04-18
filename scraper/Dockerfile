# Use Python slim as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies (lxml needs some libs)
RUN apt-get update && apt-get install -y \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy scraper code
COPY scraper.py .

# Explicitly copy service account if provided locally (for dev/test)
# In production Cloud Run, we prefer using Google Application Default Credentials
# COPY serviceAccountKey.json .

# Cloud Run expects a service to listen on PORT (usually 8080)
# Although this is a script, we keep it compatible for potential triggers
ENV PORT 8080

# Command to run the scraper
CMD ["python", "scraper.py"]
