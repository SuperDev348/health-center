const router = require("express").Router();
const authorized = require("../../middleware/authorized");
const adminOnly = require("../../middleware/admin-only");

const { insert, get, put, del, getUUID } = require("./controller");

router.get("/", get);
router.get("/:uuid", getUUID);
router.post("/", [authorized, adminOnly], insert);
router.put("/:uuid", [authorized, adminOnly], put);
router.delete("/:uuid", [authorized, adminOnly], del);

module.exports = router;
