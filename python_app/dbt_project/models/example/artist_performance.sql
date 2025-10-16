{{ config(materialized='view') }}

-- View analyzing the overall performance of artists
SELECT
    artist_id,
    artist_name,
    COUNT(DISTINCT track_id) AS total_tracks,
    MIN(position) AS best_position,
    COUNT(DISTINCT date) AS active_days
FROM {{ source('deezer', 'top_tracks') }}
GROUP BY artist_id, artist_name 
ORDER BY total_tracks
