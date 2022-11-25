const pool = require("../../db");
const { decodedToken, sendError, sError } = require("../../utils");
const queries = require("./queries");

const getMyPreviousConversations = (req, res) => {
  const uuid = decodedToken(req).uuid;

  console.log(
    "[previous-conversations/controller] getMyPreviousConversations --->",
    uuid
  );

  pool.query(
    queries.getMyPreviousConversations,
    [uuid],
    function (err, results) {
      if (err) {
        sendError(res, { msg: err });
      } else {
        res.json(results.rows);
      }
    }
  );
};

const getGroupedConversations = (req, res) => {
  const uuid = decodedToken(req).uuid;
  pool.query(
    queries.groupedPreviousConversations,
    [uuid],
    function (err, results) {
      if (err) {
        console.log(err);
        return sError(res, err);
      }
      res.json(results.rows);
    }
  );
};

module.exports = {
  getMyPreviousConversations,
  getGroupedConversations,
};
