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
ORDER BY transaction_day, transaction_rank
LIMIT 10;
