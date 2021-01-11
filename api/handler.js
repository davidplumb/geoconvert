const {
    responseJSON
} = require ("./src/lib/response");

module.exports.helloWorld = async (event) => {
    console.log("working");
    console.log(responseJSON(200, 'asdasd', false));
    
    return responseJSON(200, "hello"); 

}