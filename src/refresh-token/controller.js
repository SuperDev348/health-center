const pool = require("../../db");
const queries = require("./queries");
const { v4: uuidv4 } = require("uuid");

const insert = (tokenId, userUUID, ipAddress) => {
  return new Promise((resolve, reject) => {
    const token = uuidv4();
    pool.query(
      queries.insert,
      [tokenId, userUUID, token, ipAddress],
      function (err, results) {
        if (err) {
          reject(err);
        } else {
          resolve(token);
        }
      }
    );
  });
};

const get = (token, ipAddress) => {
  return new Promise((resolve, reject) => {
    pool.query(queries.getByRefreshToken, [token], function (err, results) {
      if (err) {
        reject(err);
      } else {
        const rows = results.rows;
        if (rows.length > 0) {
          const t = rows[0];
          if (t.reto_ip_address === ipAddress) {
            resolve(t);
          } else {
            reject("Invalid data.");
          }
        } else {
          reject("No token found");
        }
      }
    });
  });
};

const del = (token) => {
  return new Promise((resolve, reject) => {
    pool.query(queries.delByRefreshToken, [token], function (err) {
      if (err) {
        reject(err);
      } else {
        resolve();
      }
    });
  });
};

const delById = (id) => {
  return new Promise((resolve, reject) => {
    pool.query(queries.delById, [id], function (err) {
      if (err) {
        return reject(err);
      }
      resolve();
    });
  });
};

module.exports = {
  insert,
  get,
  del,
  delById,
};
