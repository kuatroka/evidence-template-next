SELECT
    cik,
    quarter,
    cusip,
    value,
    shares,
    cusip_ticker,
    name_of_issuer
FROM main.main
WHERE accession_number != 'SYNTHETIC-CLOSE' AND quarter > '1998Q1'