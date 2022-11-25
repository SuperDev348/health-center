const router = require("express").Router();
const { get, insert, del, update } = require("./controller");
const authorized = require("../../middleware/authorized");
const adminOnly = require("../../middleware/admin-only");
const validation = require("../../middleware/validation");

router.get("/", [], get);
router.post("/", [authorized, adminOnly, validation.category], insert);
router.put("/:id", [authorized, adminOnly, validation.category], update);
router.delete("/:id", [authorized, adminOnly], del);

module.exports = router;
