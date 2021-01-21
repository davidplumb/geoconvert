const db = require('./client');
const pgp = require('pg-promise')();

module.exports = {
    postcode: async (postcodes) => {
        // db.query("select ${columns^} from tracks where uniqueid in (${ids:csv})", {ids: ids, columns: columns.map(pgp.as.name).join()}, qrm.any)
        // const query = `select * from dbo.lut_postcode15jul where pcstrip15jul = any ($1)`;
        const columns = ["pcstrip15jul", "oac_2011_supergroup_name1115jul", "oac_2011_group_name1115jul", "oac_2011_subgroup_name1115jul"];
        const pcd = ["M437PT", "M36DE"];
        const res = await db.any("select ${columns^} from dbo.lut_postcode15jul where pcstrip15jul in (${postcodes:csv})", {
            columns: columns.map(pgp.as.name).join(),
            postcodes: pcd
        });
        return res;
    }
}
