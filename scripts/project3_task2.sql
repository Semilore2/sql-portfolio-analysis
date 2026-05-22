--2. Infrastructure Vulnerability Profiling
SELECT
port_name,
country,
harbor_size,
shelter_afforded,
CASE
WHEN harbor_size = 'S'
AND shelter_afforded = 'POOR'
THEN 'High Risk'
WHEN harbor_size = 'L'
AND shelter_afforded = 'Excellent'
THEN 'Premium Gateway'
ELSE 'Moderate Risk'
END AS risk_category
FROM `bigquery-public-data.geo_international_ports.world_port_index`
ORDER BY risk_category
LIMIT 10;
