const pool = require("../../db");
const queries = require("./queries");
const userRoleQueries = require("../user-role/queries");

const { v4: uuidv4 } = require("uuid");
const { body, validationResult } = require("express-validator");
const {
  sendError,
  decodedToken,
  createIfNotExists,
  uploadFile,
  deleteIfExists,
} = require("../../utils");

const uploadPath = "upload/file";

const uploadFileReq = (req, res) => {
  if (req.files && req.files.file) {
    createIfNotExists(uploadPath); // create upload folder
    uploadFile(req.files.file, {
      uploadPath: uploadPath,
    })
      .then((fName) => {
        pool.query(
          queries.insertFile,
          [uuidv4(), req.files.file.name, fName],
          function (err, results) {
            if (err || !results || results.rows <= 0) {
              deleteIfExists(uploadPath + "/" + fName);
              sendError(res, { msg: "Unable to save the file. " });
            } else {
              res.json({
                mimetype: req.files.file.mimetype,
                originalName: req.files.file.name,
                fName: fName,
                uuid: results.rows[0].file_uuid,
              });
            }
          }
        );
      })
      .catch((err) => {
        sendError(res, { msg: err });
      });
  } else {
    sendError(res, { msg: "Please select a file" });
  }
};

module.exports = {
  uploadFileReq,
};
