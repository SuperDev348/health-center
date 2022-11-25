const router = require("express").Router();
const authorized = require("../../middleware/authorized");
const { putTC, putPC, getPP, getTC } = require("./controller");

router.get("/privacy-policy", getPP);
router.get("/terms-conditions", getTC);

router.put("/privacy-policy", authorized, putPC);
router.put("/terms-conditions", authorized, putTC);

module.exports = router;
