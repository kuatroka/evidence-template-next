import { Database } from "duckdb-async";
import { quarter } from '/../../stores.js';

let quarter_filter = '';
quarter.subscribe(value => {
    quarter_filter = value
})
console.log(quarter_filter)
// AND  quarter = '${quarter_filter}'

// const conso_duckdb_file = '../../sec.duckdb';
const conso_duckdb_file = './sources/duckdb-sec/sec_full.duckdb';

export async function load({ params }) {
    const db = await Database.create(conso_duckdb_file);
    const { superinvestor } = params;

    let query_duckdb = `
    SELECT
    cik as cik,
    quarter,
    cusip,
    ANY_VALUE(cusip_ticker_name) AS cusip_ticker_name,
    ANY_VALUE(cik_name) as cik_name,
    SUM(value) AS value_usd,
    SUM(shares) AS shares,
    ROUND(SUM(value) / SUM(shares), 2) as avg_price_usd,
    ANY_VALUE(cusip_ticker) as cusip_ticker,
    ANY_VALUE(name_of_issuer) as name,
    ROUND(SUM(value) / SUM(SUM(value)) OVER (PARTITION BY cik, quarter), 2) AS pct_pct
  FROM main.main
  WHERE accession_number != 'SYNTHETIC-CLOSE' AND cik = '${superinvestor}'  
  GROUP BY cik, quarter, cusip
  ORDER BY 1, 2, 6 DESC
    `;

    console.time(query_duckdb);
    const entries = await db.all(query_duckdb);
    console.timeEnd(query_duckdb);

    await db.close();
    console.log(entries.slice(0, 3));

    return { entries };
}

