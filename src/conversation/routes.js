const { Router } = require("express");
const router = Router();

const {
  getConversation,
  getMyConversations,
  getGuestConversations,
} = require("./controller");
const { getMessages } = require("../messages/controller");
const { sendError } = require("../../utils");
const authorized = require("../../middleware/authorized");

router.get("/guest/:uuid", [], getGuestConversations);
router.get("/id/:from/:to", async (req, res) => {
  const { from, to } = req.params;
  const data = { from: from, to: to };
  getConversation(data)
    .then((id) => {
      res.json({ conversationId: id });
    })
    .catch((err) => {
      sendError(err, { msg: err });
    });
});
router.get("/messages/:uuid", [], getMessages);
router.get("/my-conversations", [authorized], getMyConversations);

module.exports = router;
