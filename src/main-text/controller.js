const pool = require("../../db");
const queries = require("./queries");
const { sendError } = require("../../utils");
const { v4: uuidv4 } = require("uuid");

const get = (req, res) => {
  pool.query(queries.getOne, function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      if (results.rows.length > 0) {
        res.json(results.rows[0]);
      } else {
        res.json();
      }
    }
  });
};

const replaceMainText = (req, res) => {
  const body = req.body;

  if (body.text && body.text_b) {
    pool.query(queries.getOne, function (err, result) {
      if (result.rows.length > 0) {
        const uuid = result.rows[0].mate_uuid;
        pool.query(queries.del, [uuid], function (err, result) {
          if (err) {
            console.log("Failed to delete previous main_text");
          }
        });
      }
      pool.query(queries.insert, [uuidv4(), body.text, body.text_b], function (err) {
        if (err) {
          sendError(res, { msg: err });
        } else {
          res.json();
        }
      });
    });
  } else {
    sendError(res, { msg: "No text was supplied" });
  }
};

module.exports = {
  replaceMainText,
  get,
};
