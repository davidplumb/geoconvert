module.exports.responseJSON = (statusCode, body, isJSON = true) => ({
    body: isJSON ? JSON.stringify(body) : body,
    headers: {
        'Access-Control-Allow-Credentials': true,
        'Access-Control-Allow-Origin': '*'
    },
    statusCode
});