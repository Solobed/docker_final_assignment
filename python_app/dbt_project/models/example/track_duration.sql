{{ config(materialized='view') }}

-- Analysis of the average duration of popular tracks
SELECT
    date,
    ROUND(AVG(duration_sec) / 60.0, 2) AS avg_duration_min,
    COUNT(DISTINCT track_id) AS track_count
FROM {{ source('deezer', 'top_tracks') }}
GROUP BY date
ORDER BY date DESC
