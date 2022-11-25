const router = require("express").Router();
const authorized = require("../../middleware/authorized");
const validation = require("../../middleware/validation.js");
const { insert, getMyRecord, getNotAccepted, accept, updateMyRecord, verifyMyPIN, doIHaveAPIN, resetPIN, setNewPIN } = require("./controller");

router.get("/not-accepted", [], getNotAccepted)
router.get("/my-record", [authorized], getMyRecord)
router.get("/have-pin", [authorized], doIHaveAPIN)

router.post("/", [authorized], insert)
router.post("/accept/:uuid", [authorized], accept)
router.post('/verify-pin', [authorized], verifyMyPIN)
router.post('/reset-pin', [authorized], resetPIN)
router.put('/', [authorized], updateMyRecord)
router.put('/pin', [authorized], setNewPIN)

module.exports = router