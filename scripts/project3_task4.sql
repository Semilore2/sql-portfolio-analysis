--4. Supply Chain Rerouting Optimization
WITH target_port AS (
  SELECT
  port_name,
  country,
  ST_GEOGPOINT(port_longitude, port_latitude) AS port_location
  FROM `bigquery-public-data.geo_international_ports.world_port_index`
  WHERE port_name = 'LAGOS'
)
SELECT
p.port_name,
p.country,
ST_DISTANCE(
t.port_location,
ST_GEOGPOINT(
  p.port_longitude,
  p.port_latitude )
) /1000 AS distance_km
FROM `bigquery-public-data.geo_international_ports.world_port_index` AS p
CROSS JOIN target_port AS t
WHERE p.country = t.country
AND p.port_name <> 'LAGOS'
ORDER BY distance_km
LIMIT 10;
