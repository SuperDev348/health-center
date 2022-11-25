const queries = require("./queries");
const pool = require("../../db");
const { v4: uuidv4 } = require("uuid");

const { sendError, isAuthorized, decodedToken } = require("../../utils");

const convQueries = require("../conversation/queries");

const getConvRec = (convUUID) => {
  return new Promise((resolve, reject) => {
    pool.query(
      convQueries.getConversationRecord,
      [convUUID],
      function (err, results) {
        if (err) {
          console.log("[conversation/controller.js] err");
          return reject(err);
        } else {
          console.log("[conversation/controller.js] else");

          if (results.rows.length > 0) {
            resolve(results.rows[0]);
          } else {
            resolve(null);
          }
        }
      }
    );
  });
};

const insertMessage = (data) => {
  return new Promise((resolve, reject) => {
    const fileUUID = data.opts && data.opts.uuid ? data.opts.uuid : null;
    pool.query(
      queries.insertMessage,
      [uuidv4(), data.conv_uuid, data.from, data.message, fileUUID],
      function (err, results) {
        if (err) {
          reject();
        } else {
          resolve();
        }
      }
    );
  });
};

const getMessagesByUuid = (convUUID) => {
  return new Promise((resolve, reject) => {
    pool.query(queries.getConvMessages, [convUUID], function (err, results) {
      if (err) {
        reject(err);
      } else {
        resolve(results.rows);
      }
    });
  });
};

const markAsRead = (convUUID, myUUID) => {
  return new Promise((resolve, reject) => {
    pool.query(queries.markReadTheirMessages, [convUUID, myUUID], (err) => {
      if (err) {
        reject(err);
      }
      resolve();
    });
  });
};

const markAsReadMine = (convUUID, myUUID) => {
  return new Promise((resolve, reject) => {
    pool.query(queries.markReadMine, [convUUID, myUUID], (err) => {
      if (err) {
        reject(err);
      }
      resolve();
    });
  });
};

const getMessages = async (req, res) => {
  const convUUID = req.params.uuid;
  let myId = null;
  if (isAuthorized(req)) {
    myId = decodedToken(req).uuid;
  }

  if (convUUID) {
    if (myId) {
      await markAsRead(convUUID, myId);
      if (convUUID && convUUID !== -1) {
        getConvRec(convUUID)
          .then((d) => {
            if (d) {
              const to = d.conv_user_a === myId ? d.conv_user_b : d.conv_user_a;
              const io = req.app.locals.io;
              console.log("TO: ", to, "FROM: ", myId);

              console.log(
                "I am " + myId + ", and I want you to show " + to,
                " that I say his message"
              );

              io.to(to).emit("your-message-read", {
                from: to,
                to: myId,
              });
            }
          })
          .catch(() => {
            console.log("No worries");
          });
      }
    }
    getMessagesByUuid(convUUID)
      .then((r) => {
        res.json(r);
      })
      .catch((err) => {
        sendError(res, { msg: err });
      });
  } else {
    sendError(res, { msg: "No conversation id was entered." });
  }
};

module.exports = {
  insertMessage,
  getMessages,
  getMessagesByUuid,
  markAsRead,
  markAsReadMine,
};
