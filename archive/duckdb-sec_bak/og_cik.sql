(SELECT cik::String as cik, ANY_VALUE(cik_name) as cik_name, COUNT(DISTINCT quarter) as unique_quarters
FROM main.main
GROUP BY cik
ORDER BY unique_quarters DESC
LIMIT 10)

union all

(SELECT cik::String as cik, ANY_VALUE(cik_name) as cik_name, (COUNT(DISTINCT quarter)*-1) as unique_quarters
FROM main.main
GROUP BY cik
ORDER BY unique_quarters desc
LIMIT 10)