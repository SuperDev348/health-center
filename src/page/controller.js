const queries = require("./queries");
const db = require("../../db");
const pool = require("../../db");
const { sendError } = require("../../utils");
const { v4: uuidv4 } = require("uuid");

const get = (req, res) => {
  pool.query(queries.get, function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json(results.rows);
    }
  });
};

const getUUID = (req, res) => {
  const uuid = req.params.uuid;
  pool.query(queries.getUUID, [uuid], function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      if (results.rows && results.rows.length > 0) {
        res.json(results.rows[0]);
      } else {
        res.json();
      }
    }
  });
};

const insert = (req, res) => {
  const { title, slug, keywords, txt } = req.body;
  pool.query(
    queries.insert,
    [uuidv4(), title, slug, keywords, txt],
    function (err, results) {
      if (err) {
        sendError(res, { msg: err });
      } else {
        res.json();
      }
    }
  );
};

const put = (req, res) => {
  const uuid = req.params.uuid;
  const { title, slug, keywords, txt } = req.body;

  pool.query(
    queries.put,
    [title, slug, keywords, txt, new Date().toISOString(), uuid],
    function (err, results) {
      if (err) {
        sendError(res, { msg: err });
      } else {
        res.json();
      }
    }
  );
};

const del = (req, res) => {
  const uuid = req.params.uuid;
  pool.query(queries.del, [uuid], function (err) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json();
    }
  });
};

module.exports = {
  insert,
  get,
  put,
  del,
  getUUID,
};
