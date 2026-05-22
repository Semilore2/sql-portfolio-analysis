--1. Global Port Capacity Audit
SELECT
country,
COUNT(*) AS total_ports,
COUNT(
  CASE
  WHEN harbor_size = 'L'
  THEN 1
  END
) AS large_ports,
COUNT (
  CASE
  WHEN harbor_size = 'M'
  THEN 1
  END
) AS medium_ports,
COUNT(
  CASE
  WHEN harbor_size = 'S'
  THEN 1
  END  
) AS small_ports
FROM `bigquery-public-data.geo_international_ports.world_port_index`
WHERE harbor_size IS NOT NULL
GROUP BY country
ORDER BY total_ports DESC
LIMIT 10;
