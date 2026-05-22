-- 2.Geographic Price Variance
WITH top_procedure AS(
  SELECT
  drg_definition,
  COUNT(*) AS procedure_count
  FROM `bigquery-public-data.medicare.inpatient_charges_2014`
  GROUP BY drg_definition
  ORDER BY procedure_count DESC
  LIMIT 10
),
state_payments AS(
  SELECT
  i.drg_definition,
  i.provider_state,
  AVG(i.average_total_payments) AS avg_payment
  FROM `bigquery-public-data.medicare.inpatient_charges_2014` AS i
  JOIN top_procedure AS t
  ON i.drg_definition = t.drg_definition
  GROUP BY
  i.drg_definition,
  i.provider_state
)
SELECT
drg_definition,
provider_state,
avg_payment,
DENSE_RANK() OVER(
  PARTITION BY drg_definition
  ORDER BY avg_payment DESC
) AS state_cost_rank
FROM state_payments
ORDER BY
drg_definition,
state_cost_rank
LIMIT 10;
