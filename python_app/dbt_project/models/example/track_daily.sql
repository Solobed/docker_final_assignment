{{ config(materialized='view') }}

-- Retrieve the daily chart
SELECT
    track_id,
    title,
    link,
    position,
    duration_sec,
    preview_url,
    artist_id,
    artist_name,
    artist_link,
    date
FROM {{ source('deezer', 'top_tracks') }}
WHERE date = CURRENT_DATE
ORDER BY position
