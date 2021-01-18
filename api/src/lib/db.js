const db = require('./client');

module.exports = {
    test: async () => {
        const lut_active = true
        const query = `select * from dbo.index_lut where lut_active = $1 and geoginst_1 = $2`
        const res = await db.query(query, [lut_active, 'MSOAIZ0115jul'])
        return res
    }
 }