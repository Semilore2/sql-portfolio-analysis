SELECT *
FROM `bigquery-public-data.medicare.inpatient_charges_2014`
LIMIT 10;

SELECT *
FROM `bigquery-public-data.medicare.part_d_prescriber_2014`
LIMIT 10;

-- 1. Hospital Cost Analysis
SELECT
provider_name,
provider_state,
AVG(average_covered_charges) AS avg_covered_charges,
AVG(average_total_payments) AS avg_total_payments,
AVG(average_covered_charges) / AVG(average_total_payments)
AS markup_ratio
FROM `bigquery-public-data.medicare.inpatient_charges_2014`
GROUP BY
provider_name,
provider_state
ORDER BY markup_ratio DESC
LIMIT 10;

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

-- 3. Statistical Outlier Detection
WITH provider_stats AS (
  SELECT
  provider_name,
  provider_state,
  average_covered_charges,
  AVG(average_covered_charges)
  OVER() AS national_avg,
  STDDEV_SAMP(average_covered_charges)
  OVER() AS national_stddev
  FROM `bigquery-public-data.medicare.inpatient_charges_2014`
)
SELECT
provider_name,
provider_state,
average_covered_charges,
national_avg,
national_stddev
FROM provider_stats
WHERE average_covered_charges > (national_avg + (2 * national_stddev))
OR average_covered_charges < (national_avg - (2 * national_stddev))
ORDER BY average_covered_charges DESC
LIMIT 10;

--4. Cross-Domain Analysis
WITH hospital_costs AS (
  SELECT
  provider_state,
  AVG(average_total_payments) AS avg_hospital_payment
  FROM `bigquery-public-data.medicare.inpatient_charges_2014`
  GROUP BY provider_state
),
prescriber_costs AS (
  SELECT
  nppes_provider_state,
  AVG(total_drug_cost) AS avg_drug_cost
  FROM `bigquery-public-data.medicare.part_d_prescriber_2014`
  GROUP BY nppes_provider_state
)
SELECT
h.provider_state,
h.avg_hospital_payment,
p.avg_drug_cost
FROM hospital_costs AS h 
INNER JOIN prescriber_costs AS p
ON h.provider_state = p.nppes_provider_state
ORDER BY h.avg_hospital_payment DESC
LIMIT 10;
