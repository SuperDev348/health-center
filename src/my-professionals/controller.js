const pool = require("../../db");
const queries = require("./queries");
const { jsPDF } = require("jspdf");

const { v4: uuidv4 } = require("uuid");

const {
  sendError,
  checkValidationError,
  decodedToken,
} = require("../../utils");
const e = require("express");

const addProfessional = (req, res) => {
  console.log("[addProfessional]");
  console.log("Add professional.");
  const { professional } = req.body;
  const uuid = decodedToken(req).uuid;
  if (uuid && professional) {
    pool.query(
      queries.professionalExists,
      [uuid, professional],
      function (err, results) {
        if (err) {
          return sendError(res, { msg: err });
        }
        const rows = results.rows;
        if (rows.length > 0) {
          res.json();
        } else {
          pool.query(
            queries.addMyProfessional,
            [uuid, professional],
            function (err, response) {
              if (err) {
                sendError(res, { msg: err });
              } else {
                const io = req.app.locals.io;
                io.to(professional).emit("chat-request");
                res.json();
              }
            }
          );
        }
      }
    );
  } else {
    sendError(res, { msg: "Invalid parameters" });
  }
};

const getMyProfessionals = (req, res) => {
  console.log("[getMyProfessionals]");

  checkValidationError(req)
    .then(() => {
      const myId = decodedToken(req).uuid;
      pool.query(queries.getMyProfessionals, [myId], function (err, results) {
        if (err) {
          console.log(err);
          sendError(res, { msg: err });
        } else {
          res.json(results.rows);
        }
      });
    })
    .catch((err) => {
      console.log(err);
      sendError(res, { msg: err });
    });
};

const getProfessionals = (req, res) => {
  console.log("[getProfessionals]");
  const myId = decodedToken(req).uuid;
  pool.query(queries.getProfessionals, function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json(results.rows);
    }
  });
};

const allow = (req, res) => {
  console.log("[allow]");
  const id = req.params.id;
  const uuid = decodedToken(req).uuid;

  pool.query(queries.setAllowed, [true, id], function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      if (results && results.rows.length > 0) {
        const io = req.app.locals.io;
        io.to(results.rows[0].mypr_uuid).emit("chat-allowed", {
          professional: uuid,
        });
      }
      res.json();
    }
  });
};

const getMyUsers = (req, res) => {
  console.log("[getMyUsers]");
  const id = decodedToken(req).uuid;
  pool.query(queries.getMyUsers, [id], function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json(results.rows);
    }
  });
};

const getNotAcceptedUsers = (req, res) => {
  console.log("[getNotAcceptedUsers]");

  const id = decodedToken(req).uuid;
  pool.query(queries.getNotAcceptedUsers, [id], function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json(results.rows);
    }
  });
};

const saveChat = (req, res) => {
  console.log("[saveChat]");

  const data = req.body;
  if (data.data) {
    const doc = new jsPDF();
    const dataUrl = data.data;
    if (dataUrl !== "data:,") {
      // eslint-disable-next-line new-cap
      const doc = new jsPDF("p", "mm");
      // var imgData = canvas.toDataURL('image/png');
      const imgData = dataUrl;

      const imgWidth = 210;
      const pageHeight = 295;
      const imgProps = doc.getImageProperties(dataUrl);
      const imgHeight = (imgProps.height * imgWidth) / imgProps.width;
      let heightLeft = imgHeight;
      let position = 0; // give some top padding to first page
      doc.addImage(imgData, "PNG", 0, position, imgWidth, imgHeight);
      heightLeft -= pageHeight;
      while (heightLeft >= 0) {
        position += heightLeft - imgHeight; // top padding for other pages
        doc.addPage();
        doc.addImage(imgData, "PNG", 0, position, imgWidth, imgHeight);
        heightLeft -= pageHeight;
      }
      const date = new Date();
      const filename =
        "chat" +
        date.getFullYear() +
        ("0" + (date.getMonth() + 1)).slice(-2) +
        ("0" + date.getDate()).slice(-2) +
        ("0" + date.getHours()).slice(-2) +
        ("0" + date.getMinutes()).slice(-2) +
        ("0" + date.getSeconds()).slice(-2) +
        ".pdf";
      doc.save("generated/" + filename);

      pool.query(
        queries.insertOldConversation,
        [uuidv4(), data.me, data.to, filename],
        function (err, results) {
          if (err) {
            sendError(res, { msg: err });
          } else {
            pool.query(
              queries.deleteConversationWithParticipants,
              [data.me, data.to],
              function (err, results) {
                if (err) {
                  sendError(res, { msg: err });
                } else {
                  pool.query(
                    queries.deleteMyProfessional,
                    [data.me, data.to],
                    function (err, results) {
                      if (err) {
                        sendError(res, { msg: err });
                      } else {
                        const io = req.app.locals.io;
                        io.to(data.me).emit("chat-deleted", {
                          me: data.me,
                          to: data.to,
                        });
                        io.to(data.to).emit("chat-deleted", {
                          me: data.me,
                          to: data.to,
                        });
                        res.json({
                          file_name: filename,
                        });
                      }
                    }
                  );
                }
              }
            );
          }
        }
      );
    } else {
      sendError(res, { msg: "Unable to generate PDF" });
    }
  } else {
    sendError(res, { msg: "No file was received" });
  }
};

const getMyProfessionalsIds = (req, res) => {
  console.log("[getmyProfessionalsIds]");
  const uuid = decodedToken(req).uuid;
  pool.query(queries.getMyProfessionalsIds, [uuid], function (err, results) {
    if (err) {
      console.log(err);
      return sendError(res, { msg: err });
    }
    const rows = results.rows;
    res.json(rows);
  });
};

module.exports = {
  addProfessional,
  getMyProfessionals,
  getProfessionals,
  allow,
  getMyUsers,
  getNotAcceptedUsers,
  saveChat,
  getMyProfessionalsIds,
};
