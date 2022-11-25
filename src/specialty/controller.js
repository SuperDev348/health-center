const pool = require("../../db");
const queries = require("./queries");
const { sError } = require("../../utils");

const get = (req, res) => {
  pool.query(queries.get, function (err, results) {
    if (err) return sError(res, err);
    res.json(results.rows);
  });
};

const put = (req, res) => {
  const id = req.params.id;
  const { category, specialty } = req.body;

  pool.query(queries.put, [category, specialty, id], function (err) {
    if (err) return sError(res, err);
    res.json();
  });
};

const del = (req, res) => {
  const id = req.params.id;
  console.log("Delete with id", id, queries.del);
  pool.query(queries.del, [id], function (err) {
    if (err) return sError(res, err);
    res.json();
  });
};

const create = (req, res) => {
  const { category, specialty } = req.body;
  pool.query(queries.insert, [category, specialty], function (err, results) {
    if (err) return sError(res, err);
    res.json(results.rows[0]);
  });
};

const specialties = (req, res) => {
  const id = req.params.id;
  pool.query(queries.specialties, [id], function (err, results) {
    if (err) return sError(res, err);
    return res.json(results.rows);
  });
};

module.exports = {
  del,
  put,
  get,
  create,
  specialties,
};
