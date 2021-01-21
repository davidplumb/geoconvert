const {
    responseJSON
} = require('./src/lib/response');

const {
    postcode
} = require('./src/lib/db');

module.exports.postcode = async (event) => {
    const {columns, postcodes} = JSON.parse(event.body)
    const data = await postcode(columns, postcodes)
    return responseJSON(200, data);
}
