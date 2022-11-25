const router = require("express").Router();
const { get, put, del, create, specialties } = require("./controller");
const authorized = require("../../middleware/authorized");
const adminOnly = require("../../middleware/admin-only");

router.get("/", [authorized, adminOnly], get);
router.get("/:id", [authorized], specialties);
router.post("/", [authorized, adminOnly], create);
router.put("/:id", [authorized, adminOnly], put);
router.delete("/:id", [authorized, adminOnly], del);

module.exports = router;
