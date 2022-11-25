const queries = require('./queries')
const { generateRandomNDigits, sendEmail, decodedToken, sendError } = require('../../utils')
const pool = require('../../db')
const {getUserById} = require('../user/queries')


function sendVerificationCode(user_uuid, email, isResetPassword, type) {
  return new Promise((resolve, reject) => {
    const code = generateRandomNDigits(9);
    isResetPassword = isResetPassword || false;

    let subject
    type = type || 'PASSWORD'
    type = type.toUpperCase()
    let html = "<h1 style='text-center'>Mednoor</h1>"

    if (type === 'PASSWORD'){
      subject = 'Reset Your Password'
    }else if (type === 'PIN') {
      subject = 'Reset Your PIN'
    }else{
      subject = 'Verification Code'
      html = "<h1>Welcome to Mednoor</h1><p>Thanks for signing up.</p>"
    }

    pool
      .query(queries.deleteVerificationCodes, [user_uuid, isResetPassword, type])
      .catch((e) => {
        console.log("Failed to delete old verification codes", e);
      })
      .finally(() => {
        pool
          .query(queries.insertVerificationCode, [
            code,
            user_uuid,
            isResetPassword,
            type
          ])
          .then(async () => {
            await sendEmail({
              to: email,
              html:
                html +
                "<p>Your verification code is <b>" +
                code +
                "</b></p>",
              subject: subject,
            })
              .then(() => {
                resolve(code);
              })
              .catch((e) => {
                console.log("Failed to send code", e);
                reject(e);
              });
          })
          .catch((e) => {
            console.log(e)
            reject(e);
          });
      });
  });
}

function deletePreviousCodes(uuid, isPassword, type) {
  return new Promise((resolve, reject)=>{
    pool.query(queries.deleteVerificationCodes, [uuid, isPassword, type], function (err, results){
      if (err){
        reject()
      }else{
        resolve()
      }
    })
  })
}

function getCode(uuid, isPassword, type){
  return new Promise((resolve, reject) => {
    pool.query(queries.getVerificationCode, [uuid, isPassword, type], function(err, results) {
      if (err){
        reject(err)
      }else{
        if (results.rows.length > 0){
          const r = results.rows[0]
          resolve(r)
        }else{
          reject('Code not found.')
        }
      }
    })
  })
}

const resetPin = (req, res) =>{
  const uuid = decodedToken(req).uuid
  pool.query(getUserById, [uuid], function(err, results){
    if (err){
      console.log(err)
      sendError(res, {msg: err})
    }else{
      if (results.rows.length > 0 && results.rows[0].user_email){
        const email = results.rows[0].user_email
        sendVerificationCode(uuid, email, false, 'PIN').then(()=>{
          res.json()
        }).catch((err)=>{
          console.log(err)
          sendError(res, {msg: err})
        })
      }else{
        sendError(res, {msg: 'Your user was not found. Please try again later'})
      }
    }
  })
}

const verifyCodeForPIN = (req, res) =>{
  const uuid = decodedToken(req).uuid
  const {code} = req.body
  if (code && code.length === 9){
    getCode(uuid, false, 'PIN').then((data)=>{
      if (data && data.veco_code === code){
        res.json({valid: true})
      }else{
        res.json({valid: false})
      }
    })
  }else{
    sendError(res, {msg: 'No valid code was provided.'})
  }
}

module.exports = {
  resetPin,
  verifyCodeForPIN,
  getCode,
  deletePreviousCodes
}