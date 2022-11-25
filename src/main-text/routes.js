const router = require("express").Router();
const authorized = require("../../middleware/authorized");
const adminOnly = require("../../middleware/admin-only");
const { get, replaceMainText } = require("./controller");

router.get("/", [], get);
router.post("/", [authorized, adminOnly], replaceMainText);

module.exports = router;
