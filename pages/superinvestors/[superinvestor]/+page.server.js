import { Database } from "duckdb-async";

// const conso_duckdb_file = '../../sec.duckdb';
const conso_duckdb_file = '../../sec_full.duckdb';

export async function load() {
    const db = await Database.create(conso_duckdb_file);
    const query_duckdb = `
        SELECT 
        cik::string as cik,
        SUM(abs(value)) as value
        FROM 
        main.main
        GROUP BY ALL
    `;

    console.time(query_duckdb);
    const entries = await db.all(query_duckdb);
    console.timeEnd(query_duckdb);

    await db.close();
    console.log(entries.slice(0, 3));

    return { entries };
}

