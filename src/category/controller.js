const pool = require("../../db");
const queries = require("./queries");
const { sendError, checkValidationError } = require("../../utils");

const get = (req, res) => {
  pool.query(queries.get, function (err, result) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json(result.rows);
    }
  });
};
const insert = (req, res) => {
  checkValidationError(req)
    .then(() => {
      const { category } = req.body;
      pool.query(queries.insert, [category], function (err, results) {
        if (err) {
          sendError(res, { msg: err });
        } else {
          res.json(results.rows[0]);
        }
      });
    })
    .catch((err) => {
      sendError(res, { msg: err });
    });
};
const del = (req, res) => {
  const id = req.params.id;
  pool.query(queries.del, [id], function (err) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json();
    }
  });
};
const update = (req, res) => {
  checkValidationError(req)
    .then(() => {
      const { category } = req.body;

      console.log(category, req.params.id);

      pool.query(queries.update, [category, req.params.id], function (err) {
        if (err) {
          console.log(err);
          sendError(res, { msg: err });
        } else {
          res.json();
        }
      });
    })
    .catch((err) => {
      sendError(res, { msg: err });
    });
};

module.exports = {
  get,
  insert,
  del,
  update,
};
