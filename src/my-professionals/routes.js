const { Router } = require("express");
const router = Router();

const {
  addProfessional,
  getMyProfessionals,
  getProfessionals,
  getMyUsers,
  allow,
  getNotAcceptedUsers,
  saveChat,
  getMyProfessionalsIds,
} = require("./controller");

const validation = require("../../middleware/validation");
const authorized = require("../../middleware/authorized");

router.post("/save-chat", authorized, saveChat);
router.post("/allow/:id", authorized, allow);
router.post("/", authorized, addProfessional);
router.get("/", authorized, getMyProfessionals);

router.get("/my-users", authorized, getMyUsers);
router.get("/not-accepted", authorized, getNotAcceptedUsers);

router.get("/all", authorized, getProfessionals);
router.get("/ids", authorized, getMyProfessionalsIds);
module.exports = router;
