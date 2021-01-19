const db = require('./client');

module.exports = {
    postcode: async (postcodes) => {
        const query = `select * from dbo.lut_postcode15jul where pcstrip15jul = any ($1)`;
        const res = await db.any(query, [postcodes]);
        return res;
    }
}
