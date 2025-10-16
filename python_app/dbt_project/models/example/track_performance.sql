{{ config(materialized='view') }}

-- View analyzing the overall performance of each track
SELECT
    track_id,
    title,
    artist_name,
    COUNT(DISTINCT date) AS days_in_chart,
    MIN(position) AS best_position
FROM {{ source('deezer', 'top_tracks') }}
GROUP BY track_id, title, artist_name
ORDER BY best_position ASC, days_in_chart DESC
