SELECT  cik::string as cik,
		ANY_VALUE(cik_name) AS cik_name,
		(SUM(value))::bigint AS value_usd
from main.main 
WHERE accession_number != 'SYNTHETIC-CLOSE'
group by 1
order by 3 DESC
limit 3