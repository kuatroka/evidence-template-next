SELECT 
cusip,
cusip_ticker,
name_of_issuer as name,
cik,
quarter,
SUM(value) as value,
SUM(shares) as shares
FROM main.main 
WHERE accession_number != 'SYNTHETIC-CLOSE'
GROUP BY cusip, cusip_ticker, name_of_issuer, cik, quarter
ORDER BY SUM(value) DESC