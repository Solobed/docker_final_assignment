import requests
import psycopg2
import os
from datetime import date, datetime

# Config PostgreSQL
DB_CONFIG = {
    "dbname": os.getenv("DB_NAME"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "host": os.getenv("DB_HOST"),
}

# URL of Deezer API
url = "https://api.deezer.com/chart/0/tracks"

params = {
    "limit": 100
 }

# Get the data
print("Lanuching the extraction.....")
response = requests.get(url, params=params)
data = response.json().get("data", [])
print("Extraction done....")

# Data Transformation
print("Launching Transformation")
tracks = []

for track in data:
    track_dict = {
        "track_id": track.get("id"),
        "title": track.get("title"),
        "link": track.get("link"),
        "position": track.get("position"),
        "duration_sec": track.get("duration"),
        "preview_url": track.get("preview"),
        "artist_id": track.get("artist", {}).get("id"),
        "artist_name": track.get("artist", {}).get("name"),
        "artist_link": track.get("artist", {}).get("link"),
        "date": date.today()
    }
    tracks.append(track_dict)
print("Transfoemation done....")

# Connexion Postgres
print("COnnexion to Postgres")
conn = psycopg2.connect(**DB_CONFIG)
cur = conn.cursor()
print("DOne....")

# Creation of the table
cur.execute("""
CREATE TABLE IF NOT EXISTS top_tracks (
    track_id BIGINT,
    title TEXT,
    link TEXT,
    position INT,
    duration_sec INT,
    preview_url TEXT,
    artist_id BIGINT,
    artist_name TEXT,
    artist_link TEXT,
    date DATE
)
""")

# Inserting data in Postgres
print("Launching Loading.....")
for track in tracks:
    cur.execute("""
        INSERT INTO top_tracks (
                track_id, title, link, position, duration_sec, preview_url,
                artist_id, artist_name, artist_link,  date
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """, (
    track['track_id'], track['title'], track['link'], track['position'], track['duration_sec'],
        track['preview_url'], track['artist_id'], track['artist_name'],
        track['artist_link'], track['date']
    ))


conn.commit()
cur.close()
conn.close()
print("Done......")
