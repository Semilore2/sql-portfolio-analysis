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
