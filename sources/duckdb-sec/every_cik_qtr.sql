SELECT *,
LEAD(total_value_quarter_all_cik_usd) OVER (PARTITION BY cik order by quarter desc) as prev_total_value_quarter_all_cik_usd,
LEAD(total_num_cik_per_quarter_num0) OVER (PARTITION BY cik order by quarter desc) as prev_total_num_cik_per_quarter_num0,
ROUND((total_value_quarter_all_cik_usd - LEAD(total_value_quarter_all_cik_usd) OVER (PARTITION BY cik order by quarter desc)) / LEAD(total_value_quarter_all_cik_usd) OVER (PARTITION BY cik order by quarter desc), 3) AS prc_change_total_value_pct,
ROUND((total_num_cik_per_quarter_num0 - LEAD(total_num_cik_per_quarter_num0) OVER (PARTITION BY cik order by quarter desc)) / LEAD(total_num_cik_per_quarter_num0) OVER (PARTITION BY cik order by quarter desc), 3) AS prc_change_total_num_cik_pct,
(SELECT COUNT(DISTINCT cusip) FROM main.main WHERE accession_number != 'SYNTHETIC-CLOSE' AND quarter = t1.quarter) AS total_assets_per_quarter_num0,
(SELECT COUNT(DISTINCT cusip) FROM main.main WHERE accession_number != 'SYNTHETIC-CLOSE' AND quarter = t1.prev_quarter) AS prev_total_assets_per_quarter_num0,
ROUND(((SELECT COUNT(DISTINCT cusip) FROM main.main WHERE accession_number != 'SYNTHETIC-CLOSE' AND quarter = t1.quarter) - (SELECT COUNT(DISTINCT cusip) FROM main.main WHERE accession_number != 'SYNTHETIC-CLOSE' AND quarter = t1.prev_quarter)) / (SELECT COUNT(DISTINCT cusip) FROM main.main WHERE accession_number != 'SYNTHETIC-CLOSE' AND quarter = t1.prev_quarter),2) AS prc_change_total_num_assets_pct
FROM 
(SELECT 
cik::String as cik, 
any_value(cik_name) as cik_name, 
quarter,
LAG(quarter) OVER (PARTITION by cik order by cik, quarter) as prev_quarter,
ANY_VALUE(CAST(SUBSTR(quarter, 1, 4) AS INTEGER) || 
    CASE 
            WHEN quarter LIKE '%Q1' THEN '-03-31'
            WHEN quarter LIKE '%Q2' THEN '-06-30'  
            WHEN quarter LIKE '%Q3' THEN '-09-30'
            WHEN quarter LIKE '%Q4' THEN '-12-31'
        END) AS quarter_end_date,
SUM(value) AS value_usd, 
LAG(SUM(value)) OVER (PARTITION by cik order by cik, quarter) as prev_value_usd,
COUNT(DISTINCT cusip) as num_assets,
LAG(COUNT(DISTINCT cusip)) OVER (PARTITION by cik order by cik, quarter) as prev_num_assets,
ROUND(((SUM(value) - LAG(SUM(value)) OVER (PARTITION by cik order by cik, quarter)) / LAG(SUM(value)) OVER (PARTITION by cik order by cik, quarter)), 2) as prc_change_value,
ROUND(((COUNT(DISTINCT cusip) - LAG(COUNT(DISTINCT cusip)) OVER (PARTITION by cik order by cik, quarter)) / LAG(COUNT(DISTINCT cusip)) OVER (PARTITION by cik order by cik, quarter)), 2) as prc_change_num_assets,
SUM(value_usd) OVER (PARTITION BY quarter) AS total_value_quarter_all_cik_usd,
COUNT(num_assets) OVER (PARTITION BY quarter) AS total_num_cik_per_quarter_num0,
FROM main.main
WHERE accession_number != 'SYNTHETIC-CLOSE' AND quarter > '1998Q1'
GROUP BY cik, quarter
ORDER BY cik, quarter DESC) as t1
ORDER BY cik, quarter DESC