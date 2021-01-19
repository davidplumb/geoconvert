const {
    responseJSON
} = require('./src/lib/response');

const {
    postcode
} = require('./src/lib/db');

module.exports.postcode = async (event) => {
    const {postcodes} = JSON.parse(event.body)
    const data = await postcode(postcodes)
    return responseJSON(200, data);
}
