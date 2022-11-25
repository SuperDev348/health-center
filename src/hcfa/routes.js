const router = require("express").Router();
const { getByOwner, createOrUpdate, getPatients } = require("./controller");
const { decodedToken, sendError } = require("../../utils");

router.get("/", (req, res) => {
    const doctorId = req.query.id;
    const patientId = req.query.patientId;
    getByOwner(doctorId, patientId)
    .then((result) => {
        res.json(result)
    })
    .catch((err) => {
        console.log(err);
        sendError(res, { msg: err });
    });
});

router.get("/patients", (req, res) => {
    getPatients()
    .then((rows) => {
        if (rows.length > 0) {
            res.json(rows);
        } else {
            res.json();
        }
    })
    .catch((err) => {
        console.log(err);
        sendError(res, { msg: err });
    });
});

router.post("/save", (req, res) => {
    const docterId = req.body.id;
    const patientId = req.body.patientId;
    const data = req.body.hcfaInfo;
    createOrUpdate(docterId, patientId, data)
    .then(() => {
        res.json();
    })
    .catch((err) => {
        sendError(res, { msg: err });
    });
});

module.exports = router;
