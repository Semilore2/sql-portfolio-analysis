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
