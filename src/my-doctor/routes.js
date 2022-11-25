const router = require('express').Router()
const {insert, get, del, doIOwnIt, toggle} = require('./controller')
const authorized = require('../../middleware/authorized')

router.get('/', [authorized], get)
router.get('/:uuid', [authorized], doIOwnIt)
router.post('/', [authorized], insert)
router.post('/toggle/:uuid', [authorized], toggle)
router.delete('/:uuid', [authorized], del)

module.exports = router