SELECT 
    quarter,
    ANY_VALUE(CAST(SUBSTR(quarter, 1, 4) AS INTEGER) || 
    CASE 
            WHEN quarter LIKE '%Q1' THEN '-03-31'
            WHEN quarter LIKE '%Q2' THEN '-06-30'  
            WHEN quarter LIKE '%Q3' THEN '-09-30'
            WHEN quarter LIKE '%Q4' THEN '-12-31'
        END) AS quarter_end_date,   
    ((quarter_end_date::date + INTERVAL '45 days'))::string AS last_reporting_date,  
    CASE WHEN now()::date > last_reporting_date THEN 'YES' ELSE 'NO' END  AS is_quarter_completed,
    COUNT(DISTINCT cik) AS num_ciks_per_quarter_num0,
    COUNT(DISTINCT cusip) AS num_cusip_per_quarter_num0,      
    SUM(value)::bigint AS total_value_per_quarter_usd,     
    (SELECT COUNT(DISTINCT cik) FROM main.main WHERE accession_number != 'SYNTHETIC-CLOSE')::integer AS total_ciks_num0,
    (SELECT COUNT(DISTINCT quarter[:4]) FROM main.main WHERE accession_number != 'SYNTHETIC-CLOSE' AND quarter > '1998Q1')::integer AS total_years,
    (SELECT COUNT(DISTINCT quarter) FROM main.main WHERE accession_number != 'SYNTHETIC-CLOSE')::integer AS total_quarters,
    ROUND((COUNT(DISTINCT cik) - LAG(COUNT(DISTINCT cik)) OVER (ORDER BY quarter)) / LAG(COUNT(DISTINCT cik)) OVER (ORDER BY quarter), 2) * 100 AS prc_change_cik,   
    ROUND((COUNT(DISTINCT cusip) - LAG(COUNT(DISTINCT cusip)) OVER (ORDER BY quarter)) / LAG(COUNT(DISTINCT cusip)) OVER (ORDER BY quarter), 2) * 100 AS prc_change_cusip,
    ROUND((SUM(value) - LAG(SUM(value)) OVER (ORDER BY quarter)) / LAG(SUM(value)) OVER (ORDER BY quarter), 2) * 100 AS prc_change_total_value        
FROM main.main    
WHERE accession_number != 'SYNTHETIC-CLOSE' AND quarter > '1998Q1'   
GROUP BY quarter 
ORDER BY quarter DESC