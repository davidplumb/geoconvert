const { responseJSON } = require('./src/lib/response');
const { postcode, postcodewildcard } = require('./src/lib/db');

module.exports.postcode = async (event) => {
    const {columns, postcodes} = JSON.parse(event.body)
    const data = await postcode(columns, postcodes)
    return responseJSON(200, data);
}

module.exports.postcodewildcard = async (event) => {
    const {columns, postcodewildcards} = JSON.parse(event.body)
    const data = await postcodewildcard(columns, postcodewildcards)
    return responseJSON(200, data);
}
