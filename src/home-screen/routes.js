const Router = require("express").Router;
const router = Router();
const authorized = require("../../middleware/authorized");
const { replaceHomeScreen, getHomeScreen } = require("./controller");

// router.get("/", getHomeScreen);
router.post("/", [authorized], replaceHomeScreen);

module.exports = router;
