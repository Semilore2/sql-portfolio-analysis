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
ORDER BY transaction_day
LIMIT 10;
