SELECT `hash`, from_address, to_address, value, block_timestamp
FROM `bigquery-public-data.crypto_ethereum.transactions`
WHERE block_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 DAY)
LIMIT 10;

--1. Network Congestion & Fee Trends
SELECT
DATE(block_timestamp) AS transaction_day,
COUNT(*) AS transaction_count,
SUM(value/POWER(10,18)) AS total_eth_transferred,
AVG(gas_price/POWER(10,9)) AS avg_gas_price_gwei
FROM `bigquery-public-data.crypto_ethereum.transactions`
WHERE DATE(block_timestamp)
BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
AND CURRENT_DATE()
GROUP BY transaction_day
ORDER BY transaction_day
LIMIT 20;

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
ORDER BY total_eth DESC;

--3. Daily Top-Value Transfers
WITH ranked_transactions AS(
  SELECT
  DATE(block_timestamp) AS transaction_day,
  from_address,
  to_address,
  value/POWER(10,18) AS eth_value,
  ROW_NUMBER() OVER (
    PARTITION BY DATE(block_timestamp)
    ORDER BY value DESC
    ) AS transaction_rank
 FROM `bigquery-public-data.crypto_ethereum.transactions`
 WHERE DATE(block_timestamp)
 BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
 AND CURRENT_DATE()
)
SELECT
transaction_day,
from_address,
to_address,
eth_value,
transaction_rank
FROM ranked_transactions
WHERE transaction_rank <= 5
ORDER BY transaction_day, transaction_rank;

--4. Rolling Cost Forecast
WITH daily_gas AS(
  SELECT
  DATE(block_timestamp) AS transaction_day,
  AVG(gas_price/POWER(10,9)) AS avg_gas_price_gwei
  FROM `bigquery-public-data.crypto_ethereum.transactions`
  GROUP BY transaction_day
)
SELECT
transaction_day,
avg_gas_price_gwei,
AVG(avg_gas_price_gwei) OVER(
  ORDER BY daily_gas.transaction_day ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
) AS moving_avg_7days
FROM daily_gas
ORDER BY transaction_day;
