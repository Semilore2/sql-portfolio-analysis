--2. Whale Wallet Tier Segmentation
SELECT
from_address,
SUM(value/POWER(10,18)) AS total_eth,
CASE
WHEN SUM(value/POWER(10,18)) >= 100
THEN 'Whale'
WHEN SUM(value/POWER(10,18))
BETWEEN 100 AND 99
THEN 'Shark'
ELSE 'Fish'
END AS wallet_tier
FROM `bigquery-public-data.crypto_ethereum.transactions`
WHERE from_address IS NOT NULL
GROUP BY from_address
HAVING total_eth > 0
ORDER BY total_eth DESC
LIMIT 10;
