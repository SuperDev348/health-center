const pool = require('../../db')
const queries = require('./queries')
const { decodedToken, sendError } = require('../../utils')
const { v4: uuidv4 } = require('uuid')




const insert = (req, res) => {
  const owner = decodedToken(req).uuid
  const { uuid } = req.body
  if (uuid) {
    pool.query(queries.insert, [uuidv4(), owner, uuid], function(err) {
      if (err) {
        sendError(res, { msg: err })
      } else {
        res.json()
      }
    })
  } else {
    sendError(res, { msg: 'No uuid provided.' })
  }
}

const get = (req, res) => {
  const uuid = decodedToken(req).uuid
  console.log('Get --->', req.params, req.query)

  pool.query(queries.get, [uuid], function(err, results) {
    if (err) {
      sendError(res, { msg: err })
    } else {
      console.log(results.rows)
      res.json(results.rows)
    }
  })
}

const del = (req, res) => {
  const uuid = req.params.uuid
  pool.query(queries.del, [uuid], function(err) {
    if (err) {
      sendError(res, { msg: err })
    } else {
      res.json()
    }
  })
}

const doIOwnIt = (req, res) => {
  const uuid = req.params.uuid
  const owner = decodedToken(req).uuid

  pool.query(queries.doIOwnIt, [owner, uuid], function(err, results) {
    if (err){
      sendError(res, {msg: err})
    }else{
      if (results.rows.length > 0){
        console.log(results.rows[0])
        res.json({owned: true})
      }else{
        res.json({owned: false})
      }
    }
  })
}

const toggle = (req, res) =>{
  const owner = decodedToken(req).uuid
  const uuid = req.params.uuid
  pool.query(queries.doIOwnIt, [owner, uuid], function(err, results) {
    if (err){
      sendError(res, {msg: err})
    }else{
      if (results.rows.length > 0){
        const r = results.rows[0]
        console.log(r)
        pool.query(queries.del, [r.mydo_uuid], function(err) {
          if (err){
            console.log(err)
            sendError(res, {msg: err})
          }else{
            res.json()
          }
        })
      }else{
        pool.query(queries.insert, [uuidv4(), owner, uuid], function (err) {
          if (err){
            sendError(res, {msg: err})
          }else{
            if (err){
              sendError(res, {msg: err})
            }else{
              res.json()
            }
          }
        })
      }
    }
  })

}

module.exports = {
  insert,
  get,
  del,
  doIOwnIt,
  toggle
}