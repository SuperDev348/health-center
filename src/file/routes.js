const { Router } = require("express");
const router = Router();
const authorized = require("../../middleware/authorized");
const { uploadFileReq } = require("./controller");

router.post("/", [authorized], uploadFileReq);

module.exports = router;
