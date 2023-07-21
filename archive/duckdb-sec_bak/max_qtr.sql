SELECT  MAX(quarter) as max_reported_quarter,
        MAX(quarter)[:4]::integer as max_year,
		COUNT(DISTINCT cik) as num_ciks 
from main.main
where accession_number != 'SYNTHETIC-CLOSE'