import { Database } from "duckdb-async";

// const conso_duckdb_file = '../../sec.duckdb';
const conso_duckdb_file = './sources/duckdb-sec/sec_full_tr.duckdb';

export async function load({ params }) {
    const db = await Database.create(conso_duckdb_file);
    const { superinvestor } = params;

    let query_duckdb = `
    SELECT cusip, name_of_issuer AS name, value_usd AS value, shares, cusip_ticker,  quarter, pct_pct
    FROM main.all_cik_quarter_cusip
    where cik = '${superinvestor}' `;
    console.time(query_duckdb);
    const entries = await db.all(query_duckdb);
    console.timeEnd(query_duckdb);

    await db.close();
    console.log(entries.slice(0, 1));
    return { entries };
}











