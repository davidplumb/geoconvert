const db = require('./client');
const pgp = require('pg-promise')();


module.exports = {
    postcode: async (columns, postcodes) => {
        
        const cols = columns || ['pcstrip15jul'];

        if(!cols.includes('pcstrip15jul')) {
            cols.push('pcstrip15jul')
        }

        const pcs = postcodes.map((e) => e.replace(/\s+/g, ''));

        const data = await db.any("select ${cols:raw} from dbo.lut_postcode15jul where pcstrip15jul in (${pcs:csv})", {
            cols: cols.map(pgp.as.name).join(),
            pcs
        });
        
        const meta = await db.any("select geoginst_lower, field_label from dbo.index_pdfield where geoginst_lower in (${cols:csv})", {
            cols
        });

        return {
            data,
            meta
        };
    }
}
