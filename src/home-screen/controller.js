const queries = require("./queries");
const { sendError, deleteIfExists, uploadFile } = require("../../utils");
const pool = require("../../db");
const uploadPath = "upload/hs/";
const { v4: uuidv4 } = require("uuid");
/*
const getHomeScreen = (req, res) => {
  console.log(req.body, req.params, req.query);
  pool.query(queries.getCurrent, [""], function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      const r = results.rows.length > 0 ? results.rows[0] : null;
      res.json({ screen: r });
    }
  });
};
*/
const replaceHomeScreen = (req, res) => {
  if (req.files && req.files.file) {
    if (req.body.type) {
      const type = req.body.type.toLowerCase();

      if (type === "sign-up" || type === "sign-in") {
        pool.query(queries.getCurrent, [type], function (err, results) {
          if (err) {
            console.log(err);
            sendError(res, { msg: err });
          } else {
            const current = results.rows.length > 0 ? results.rows[0] : null;
            new Promise((resolve) => {
              if (current) {
                deleteIfExists(uploadPath + type + ".png");
                pool.query(queries.del, [current.hosc_uuid], function () {
                  resolve();
                });
              } else {
                resolve();
              }
            }).then(() => {
              uploadFile(req.files.file, {
                uploadPath: uploadPath,
                generateName: false,
                name: type + ".png",
              })
                .then((fileName) => {
                  pool.query(
                    queries.insert,
                    [uuidv4(), fileName, type],
                    function (err, results) {
                      if (err) {
                        sendError(res, { msg: err });
                      } else {
                        res.json({ fileName });
                      }
                    }
                  );
                })
                .catch((err) => {
                  console.log(err)
                  sendError(res, { msg: err });
                });
            });
          }
        });
      } else {
        sendError(res, {
          msg: "sign-in or sign-up options must be specified.",
        });
      }
    } else {
      sendError(res, { msg: "sign-in or sign-up options must be specified." });
    }
  } else {
    sendError(res, { msg: "File was not provided" });
  }
};

module.exports = {
  replaceHomeScreen,
  // getHomeScreen,
};
