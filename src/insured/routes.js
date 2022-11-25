const router = require("express").Router();
const { getById, createOrUpdate } = require("./controller");
const { decodedToken, sendError } = require("../../utils");

router.get("/", (req, res) => {
    const user_uuid = req.query.id;
    getById(user_uuid)
    .then((result) => {
        res.json(result)
    })
    .catch((err) => {
        console.log(err);
        sendError(res, { msg: err });
    });
});

router.post("/save", (req, res) => {
    const {user_uuid, insured_info} = req.body;
    createOrUpdate(user_uuid, insured_info)
    .then(() => {
        res.json();
    })
    .catch((err) => {
        sendError(res, { msg: err });
    });
});

module.exports = router;
