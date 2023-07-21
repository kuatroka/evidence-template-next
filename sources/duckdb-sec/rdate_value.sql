SELECT  
		date_trunc('year', rdate) as year,
		SUM(value) AS value_usd,
        count(distinct cik) as investors,
        count(distinct cusip_ticker) as tickers_num0
from main.main 
WHERE accession_number != 'SYNTHETIC-CLOSE' AND quarter > '1998Q1'
group by year 
ORDER by year ASC