const Router = require("express").Router;
const router = Router();
const {
  getMyPreviousConversations,
  getGroupedConversations,
} = require("./controller");
const authorized = require("../../middleware/authorized");

router.get("/", [authorized], getMyPreviousConversations);
router.get("/grouped", [authorized], getGroupedConversations);
module.exports = router;
