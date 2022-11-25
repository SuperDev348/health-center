const router = require("express").Router();
const { getByOwnerNType } = require("./controller");
const authorized = require("../../middleware/authorized");
const { decodedToken, sendError } = require("../../utils");

router.get("/", [authorized], (req, res) => {
  const isPatient = req.query.is_patient || false;
  const owner = decodedToken(req).uuid;

  console.log("isPatient --->", isPatient);

  getByOwnerNType(owner, isPatient)
    .then((rows) => {
      if (rows.length > 0) {
        res.json(rows[0]);
      } else {
        res.json();
      }
    })
    .catch((err) => {
      sendError(res, { msg: err });
    });
});

module.exports = router;
