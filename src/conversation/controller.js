const queries = require("./queries");
const pool = require("../../db");
const { v4: uuidv4 } = require("uuid");
const { decodedToken, sendError } = require("../../utils");
const { isGuest } = require("../user/controller");
const { getMessagesByUuid } = require("../messages/controller");

const existsConversation = (data) => {
  return new Promise((resolve) => {
    pool.query(
      queries.conversationExists,
      [data.from, data.to],
      function (err, results) {
        if (err) {
          resolve(-1);
        } else {
          if (results.rows.length > 0) {
            resolve(results.rows[0].conv_uuid);
          } else {
            resolve(-1);
          }
        }
      }
    );
  });
};

const insertConversation = (data) => {
  return new Promise((resolve) => {
    pool.query(
      queries.insertConversation,
      [uuidv4(), data.from, data.to],
      function (err, results) {
        if (err) {
          resolve(-1);
        } else {
          if (results.rows && results.rows.length > 0) {
            resolve(results.rows[0].conv_uuid);
          } else {
            resolve(-1);
          }
        }
      }
    );
  });
};

// Get conversation id
const getConversation = async (data) => {
  return new Promise((rs) => {
    existsConversation(data).then(async (cid) => {
      new Promise((resolve) => {
        if (cid === -1) {
          insertConversation(data).then((cid2) => {
            rs(cid2);
          });
        } else {
          rs(cid);
        }
      });
    });
  });
};

const getMyConversations = (req, res) => {
  const userId = decodedToken(req).uuid;
  pool.query(queries.getMyConversations, [userId], function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json(results.rows);
    }
  });
};

const getGuestConversations = (req, res) => {
  const userId = req.params.uuid;

  isGuest(userId).then((isGuest) => {
    if (isGuest) {
      pool.query(queries.getMyConversations, [userId], function (err, results) {
        if (err) {
          sendError(res, { msg: err });
        } else {
          if (results.rows.length > 0) {
            const convId = results.rows[0].conv_uuid;
            getMessagesByUuid(convId)
              .then((messages) => {
                res.json(messages);
              })
              .catch(() => {
                sendError(res, {});
              });
          } else {
            res.json();
          }
        }
      });
    } else {
      res.json({});
    }
  });
};

module.exports = {
  getConversation,
  getMyConversations,
  getGuestConversations,
  existsConversation,
};
