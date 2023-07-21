SELECT 
cik::String as cik, 
any_value(cik_name) as cik_name, 
quarter as quarter,
SUM(value) AS value_usd,
COUNT(DISTINCT cusip) as num_assets
FROM main.main
WHERE accession_number != 'SYNTHETIC-CLOSE' AND quarter > '1998Q1'
GROUP BY cik, quarter
ORDER BY cik, quarter DESC







-- SELECT t.cik::String as cik, 
-- any_value(lq.cik_name) as cik_name, 
-- SUM(t.value) AS value_usd, 
-- t.quarter as quarter, 
-- count(num_tickers) as num_tickers
-- FROM main.main  AS t
-- JOIN (
--     SELECT cik, any_value(cik_name) as cik_name , MAX(quarter) AS latest_quarter, count(distinct cusip_ticker) as num_tickers,
--     FROM main.main
--     WHERE accession_number != 'SYNTHETIC-CLOSE'
--     GROUP BY cik
-- ) AS lq ON t.cik = lq.cik AND t.quarter = lq.latest_quarter
-- WHERE t.accession_number != 'SYNTHETIC-CLOSE' 
-- GROUP BY t.cik, t.quarter
-- ORDER BY value_usd DESC