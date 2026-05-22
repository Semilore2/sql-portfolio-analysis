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
