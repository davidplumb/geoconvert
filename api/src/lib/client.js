const pgp = require('pg-promise')();

const db = () => {
    switch (process.env.stage) {
        case 'local':
            return pgp({
                database: 'postgres',
                host: 'ukdsgeoconvertdev.c617xf4dogyp.eu-west-1.rds.amazonaws.com',
                password: 'PfCoFYvuTJqlsFUq',
                port: '5432',
                user: 'postgres'
            });
        case 'dev':
            return pgp({
                database: 'postgres',
                host: 'ukdsgeoconvertdev.c617xf4dogyp.eu-west-1.rds.amazonaws.com',
                password: 'PfCoFYvuTJqlsFUq',
                port: '5432',
                user: 'postgres'
            });
        default:
            return null;
    }
};

module.exports = db();
