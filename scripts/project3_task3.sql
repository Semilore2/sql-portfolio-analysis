--3. Regional Logistics Gateway Ranking
SELECT
port_name,
country,
region_number,
harbor_size,
DENSE_RANK() OVER (
  PARTITION BY region_number 
  ORDER BY harbor_size DESC
) AS regional_rank
FROM `bigquery-public-data.geo_international_ports.world_port_index`
QUALIFY regional_rank <= 3
ORDER BY
region_number,
regional_rank
LIMIT 10;
