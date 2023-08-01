import { Database } from "duckdb-async";

// const conso_duckdb_file = '../../sec.duckdb';
const conso_duckdb_file = './sources/duckdb-sec/sec_full_tr.duckdb';

export async function load({ params }) {

    const db = await Database.create(conso_duckdb_file);
    const { superinvestor, asset } = params;

    let query_duckdb = `
    SELECT 
        cik::String as cik,
        cusip,
        COUNT( (cusip, tr_type)) AS num_tr,
    FROM main.main
    WHERE tr_type == 'OPEN' AND cik = '${superinvestor}' AND cusip = '${asset}'
    GROUP BY cik, cusip`;

    console.time(query_duckdb);
    const tr_count = await db.all(query_duckdb);
    console.timeEnd(query_duckdb);

    await db.close();
    console.log(tr_count.slice(0, 1));
    return { tr_count };
}











