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
LIMIT 10;
