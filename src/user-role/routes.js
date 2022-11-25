const { Router } = require("express");
const router = Router();

const { getRoles, getRoleById } = require("./controller");

router.get("/", getRoles);
router.get("/:id", getRoleById);

module.exports = router;
