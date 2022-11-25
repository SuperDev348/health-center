const pool = require("../../db");
const queries = require("./queries");
const { v4: uuidv4 } = require("uuid");

const getByOwner = (owner) => {
  return new Promise((resolve, reject) => {
    pool.query(queries.getByOwner, [owner], function (err, results) {
      if (err) return reject(err);
      resolve(results.rows);
    });
  });
};

const getByOwnerNType = (owner, isPatient) => {
  return new Promise((resolve, reject) => {
    pool.query(
      queries.getByOwnerNType,
      [owner, isPatient],
      function (err, results) {
        if (err) return reject(err);
        resolve(results.rows);
      }
    );
  });
};

const createOrUpdate = (owner, data) => {
  return new Promise((resolve, reject) => {
    const isPatient = data.is_patient || false;
    getByOwnerNType(owner, isPatient)
      .then((rows) => {
        if (rows.length > 0) {
          // Update record because it exists.
          pool.query(
            queries.put,
            [data.line1, data.city, data.state, data.zip, owner, isPatient],
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
              uuidv4(),
              data.line1,
              data.city,
              data.state,
              data.zip,
              owner,
              isPatient,
            ],
            function (err) {
              if (err) return reject(err);
              resolve();
            }
          );
        }
      })
      .catch((err) => {
        return reject(err);
      });
  });
};

module.exports = {
  createOrUpdate,
  getByOwner,
  getByOwnerNType,
};
