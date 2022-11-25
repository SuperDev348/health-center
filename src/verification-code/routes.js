const router = require('express').Router()
const authorized = require('../../middleware/authorized')
const {resetPin, verifyCodeForPIN} = require('./controller')

router.post('/pin', [authorized], resetPin)
router.post('/verify-pin', [authorized], verifyCodeForPIN)

module.exports = router