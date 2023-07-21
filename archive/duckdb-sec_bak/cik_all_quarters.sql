SELECT  cik::string as cik,
quarter,
any_value(cik_name) as cik_name,
ANY_VALUE(cusip_ticker) as cusip_ticker,
count (distinct cusip) as num_cusip,
count (distinct quarter) as num_qtr,
SUM(abs(value)) as value_usd,
(sum(value) - LAG(sum(value)) OVER (ORDER BY quarter)) / LAG(sum(value)) OVER (ORDER BY quarter) * 100 AS prc_change,
ROUND((SUM(abs(value)) / count (distinct cusip)),2) as avg_portfolio_price_usd,
from main.main 
WHERE accession_number != 'SYNTHETIC-CLOSE'
group by 1,2
order by 1,2 DESC