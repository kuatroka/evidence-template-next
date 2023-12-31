import { Database } from "duckdb-async";

// const conso_duckdb_file = '../../sec.duckdb';
const conso_duckdb_file = './sources/duckdb-sec/sec_full_tr.duckdb';

export async function load({ params }) {

    const db = await Database.create(conso_duckdb_file);
    const { superinvestor, asset } = params;

    let query_duckdb = `
    SELECT 
    tr_id,
    cik::string AS cik,
    '?tr_id=' || tr_id as link,
    RIGHT(tr_id, 6) AS tr_open,
    ROW_NUMBER() OVER( ORDER BY tr_open) AS tr_number, 
    CASE
        WHEN ANY_VALUE(tr_type)  = 'CLOSE' THEN ANY_VALUE(quarter)
    END AS tr_close,
    MAX(CASE WHEN tr_type = 'OPEN' THEN tr_value END) AS tr_open_value,
    MAX(CASE WHEN tr_type = 'OPEN' THEN tr_shares END) AS tr_open_shares,
    ROUND((tr_open_value / tr_open_shares), 2) AS sec_tr_open_price,
    MAX(CASE WHEN tr_type = 'CLOSE' THEN ABS(tr_value) END) AS tr_close_value,
    MAX(CASE WHEN tr_type = 'CLOSE' THEN ABS(tr_shares) END) AS tr_close_shares,
    ROUND((tr_close_value / tr_close_shares), 2) AS sec_tr_close_price,
    ROUND((sec_tr_close_price / sec_tr_open_price) - 1, 2) AS sec_pl_non_adj,  
    (SELECT COUNT(DISTINCT tr_id) FROM main.main WHERE cik = '${superinvestor}' AND cusip = '${asset}') AS num_tr,
    ANY_VALUE(name_of_issuer) AS name_of_issuer,
    ANY_VALUE(cik_name) AS cik_name,
    ANY_VALUE(cusip) AS cusip,
    ANY_VALUE(tr_duration_qtr) AS tr_duration_qtr,
    ANY_VALUE(tr_pnl_prc) AS tr_pnl,
    FROM main.main
    WHERE cik = '${superinvestor}' AND cusip = '${asset}'
    GROUP BY 1, 2
    ORDER BY tr_open ASC`;


    let query_duckdb2 = `
    SELECT
        cusip,
        quarter,
        tr_id,
        tr_type,
        tr_value,
        tr_shares,
                ROUND(CASE 
                    WHEN tr_type = 'CLOSE' THEN tr_value / tr_shares
                    ELSE value / shares
            END, 2) AS price,
        ROUND((tr_value / tr_shares), 2) AS sec_tr_price,
        ROUND((value / shares), 2) AS sec_price,
        cik::string AS cik,
        RIGHT(tr_id, 6) AS tr_open, 
        name_of_issuer,
        cik_name,
        value,
        shares,
        qtr_pnl_prc
        FROM main.main
        WHERE cik = '${superinvestor}' AND cusip = '${asset}'
        ORDER BY cusip, quarter`

        let query_duckdb3 = `
        SELECT 
        cik::string AS cik,
        cik_name,
        '/superinvestors/' || cik::string  || '/${asset}'as link,
        COUNT(DISTINCT tr_id) AS num_tr_per_cik, 
        ROUND(AVG(DISTINCT tr_pnl_prc),2) AS avg_tr_pnl_per_cik,
        (SELECT COUNT(DISTINCT tr_id) FROM main.main WHERE cusip = '${asset}') AS total_num_tr,
        (SELECT COUNT(DISTINCT cik) FROM main.main WHERE cusip = '${asset}') AS total_num_cik,
        FROM main.main
        WHERE cusip = '${asset}'
        GROUP BY 1, 2
        `



    console.time(query_duckdb);
    const tr_per_cik = await db.all(query_duckdb);
    console.timeEnd(query_duckdb);

    console.time(query_duckdb);
    const tr_per_cik_drilldown = await db.all(query_duckdb2);
    console.timeEnd(query_duckdb);

    console.time(query_duckdb3);
    const other_cik_per_cusip = await db.all(query_duckdb3);
    console.timeEnd(query_duckdb3);

    await db.close();
    console.log(tr_per_cik.slice(0, 2));
    console.log(tr_per_cik_drilldown.slice(0, 2));
    console.log(other_cik_per_cusip.slice(0, 2));
    return { tr_per_cik, tr_per_cik_drilldown, other_cik_per_cusip };
}











