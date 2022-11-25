const pool = require("../../db");
const queries = require("./queries");


const getById = (user_uuid) => {
    return new Promise((resolve, reject) => {
        pool.query(queries.getRecord, [user_uuid], function (err, results) {
            let claims_info = {};

            if (results && results.rows && results.rows.length > 0) {
                claims_info = results.rows[0].claims_info;
            }
            if (err) return reject(err);
            resolve(claims_info)
        });
    });
};

const createOrUpdate = (user_uuid, claims_info) => {
    return new Promise((resolve, reject) => {
        pool.query(queries.getRecord, [user_uuid], function (err, results) {
            if (err) {
                return reject(err);
            }
            const { rows } = results
            if (rows && rows.length > 0) {
            // Update record because it exists.
                pool.query(
                    queries.put,
                    [
                        user_uuid,
                        claims_info
                    ],
                    function (err) {
                        if (err) return reject(err);

                        resolve();
                    }
                );
            } else {
                // Create record
                pool.query(
                    queries.insert,
                    [
                        user_uuid,
                        claims_info
                    ],
                    function (err) {
                        if (err) return reject(err);
                        resolve();
                    }
                );
            }
        })
    });
};

module.exports = {
    createOrUpdate,
    getById,
};
  