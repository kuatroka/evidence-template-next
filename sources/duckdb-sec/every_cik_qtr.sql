SELECT 
cik::String as cik, 
any_value(cik_name) as cik_name, 
quarter,
ANY_VALUE(CAST(SUBSTR(quarter, 1, 4) AS INTEGER) || 
    CASE 
            WHEN quarter LIKE '%Q1' THEN '-03-31'
            WHEN quarter LIKE '%Q2' THEN '-06-30'  
            WHEN quarter LIKE '%Q3' THEN '-09-30'
            WHEN quarter LIKE '%Q4' THEN '-12-31'
        END) AS quarter_end_date,
SUM(value) AS value_usd, 
LAG(SUM(value)) OVER (order by cik, quarter) as prev_value_usd,
COUNT(DISTINCT cusip) as num_assets,
LAG(COUNT(DISTINCT cusip)) OVER (order by cik, quarter) as prev_num_assets
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