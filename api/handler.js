const { responseJSON } = require ("./src/lib/response");
const { test } = require("./src/lib/db");

module.exports.helloWorld = async (event) => {
    const data = await test()
    console.log(data);
    return responseJSON(200, data);
}