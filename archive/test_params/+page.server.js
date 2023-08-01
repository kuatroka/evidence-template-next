import { Database } from "duckdb-async";

// const conso_duckdb_file = '../../sec.duckdb';
const conso_duckdb_file = './sources/duckdb-sec/sec_full.duckdb';

export async function load({ params }) {
    const db = await Database.create(conso_duckdb_file);
    // const { superinvestor } = params;

    let query_duckdb = `
    SELECT quarter, name_of_issuer, cusip_ticker, value_usd, pct_pct
    FROM main.all_cik_quarter_cusip
    limit 10`;
    console.time(query_duckdb);
    const entries = await db.all(query_duckdb);
    console.timeEnd(query_duckdb);

    await db.close();
    console.log(entries.slice(0, 1));
    return { entries };
}











