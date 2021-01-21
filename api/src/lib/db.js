const db = require('./client');
const pgp = require('pg-promise')();

module.exports = {
    postcode: async (columns, postcodes) => {
        const data = await db.any("select ${columns:raw} from dbo.lut_postcode15jul where pcstrip15jul in (${postcodes:csv})", {
            columns: columns.map(pgp.as.name).join(),
            postcodes
        });
        const meta = await db.any("select geoginst_lower, field_label from dbo.index_pdfield where geoginst_lower in (${columns:csv})", {
            columns
        });
        return {
            data,
            meta
        };
    }
}
