const pool = require("../../db");
const queries = require("./queries");
const { sendError } = require("../../utils");

const getTC = (req, res) => {
  pool.query(queries.getTC, function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      if (results.rows && results.rows.length > 0) {
        res.json(results.rows[0]);
      } else {
        res.json({});
      }
    }
  });
};

const getPP = (req, res) => {
  pool.query(queries.getPP, function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      if (results.rows && results.rows.length > 0) {
        res.json(results.rows[0]);
      } else {
        res.json({});
      }
    }
  });
};

const putTC = (req, res) => {
  pool.query(queries.deleteTC, function (err) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      const tc = req.body.txt;
      pool.query(queries.insertTC, [tc], function (err) {
        if (err) {
          sendError(res, { msg: err });
        } else {
          res.json();
        }
      });
    }
  });
};

const putPC = (req, res) => {
  pool.query(queries.deletePrivacyPolicy, function (err) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      const tc = req.body.txt;
      pool.query(queries.insertPrivacyPolicy, [tc], function (err) {
        if (err) {
          sendError(res, { msg: err });
        } else {
          res.json();
        }
      });
    }
  });
};

module.exports = {
  putPC,
  putTC,
  getTC,
  getPP,
};
