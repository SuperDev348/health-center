const pool = require("../../db");
const queries = require("./queries");
const { sendError } = require("../../utils");

const getRoles = (req, res) => {
  pool.query(queries.getRoles, (error, results) => {
    if (error) {
      sendError(res, { msg: error });
    } else {
      res.json(results.rows);
    }
  });
};

const getRoleById = (req, res) => {
  const id = parseInt(req.params.id);
  pool.query(queries.getRoleById, [id], (error, results) => {
    if (error) throw error;
    res.json(results.rows);
  });
};

const getRoleByKey = async function (roleKey) {
  let rt = -1;
  await pool
    .query(queries.getRoleByKey, [roleKey])
    .then((results) => {
      rt = results.rows;
    })
    .catch(() => {
      rt = -1;
    });
  return rt;
};

module.exports = {
  getRoles,
  getRoleById,
  getRoleByKey,
};
