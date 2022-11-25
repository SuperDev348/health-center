const pool = require("../../db");
const queries = require("./queries");
const userQueries = require("../user/queries");
const {
  sendError,
  checkValidationError,
  decodedToken,
  generateRandomNDigits,
  sendEmail,
} = require("../../utils");
const { updateToProfessional, getAdminFn } = require("../user/controller");
const { v4: uuidv4 } = require("uuid");
const {
  getCode,
  deletePreviousCodes,
} = require("../verification-code/controller");

const { createOrUpdate } = require("../address/controller");

const getAccepted = (req, res) => {
  pool.query(queries.getAccepted, function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json(results);
    }
  });
};

const getNotAccepted = (req, res) => {
  pool.query(queries.getNotAccepted, function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json(results.rows);
    }
  });
};

function emailStartProfessional(userId) {
  pool.query(userQueries.getUserById, [userId], function (err, results) {
    const c = results.rows;
    if (c.length > 0) {
      const d = c[0];
      if (d && d.user_email) {
        sendEmail({
          to: d.user_email,
          html: '<h1>Thank you for starting the Professional status at Mednoor</h1><p>Please go to "My Profile" and complete your information.</p>',
          subject: "Complete Profile II",
        })
          .then(() => {
            console.log("Email sent successfully.");
          })
          .catch(() => {
            console.log("Failed to notify admin");
          });
      }
    }
  });
}

const insert = (req, res) => {
  checkValidationError(req)
    .then(() => {
      const { category, npi } = req.body;
      const userId = decodedToken(req).uuid;
      pool.query(
        queries.insert,
        [uuidv4(), category, npi, false, null, userId],
        function (err) {
          if (err) {
            sendError(res, { msg: err });
          } else {
            console.log("**** Insert ****");
            emailStartProfessional(userId);
            res.json();
          }
        }
      );
    })
    .catch((err) => sendError(res, { msg: err }));
};

const getMyRecord = (req, res) => {
  const userUuid = decodedToken(req).uuid;
  pool.query(queries.getMyRecord, [userUuid], function (err, results) {
    if (err) return sendError(res, { msg: err });
    if (results.rows.length > 0) {
      const r = results.rows[0];
      if (r["profe_pin"] && r["profe_pin"].length === 6) {
        r.has_pin = true;
      }
      delete r["profe_pin"];
      res.json(r);
    } else {
      res.json();
    }
  });
};

const accept = (req, res) => {
  const recordId = req.params.uuid;
  pool.query(queries.getRecord, [recordId], function (err, results) {
    if (err) {
      return sendError(res, { msg: err });
    }
    if (results.rows.length > 0) {
      const uuid = results.rows[0].profe_user_uuid;
      updateToProfessional(uuid)
        .then(() => {
          pool.query(
            queries.accept,
            [generateRandomNDigits(6), uuid],
            function (err) {
              if (err) {
                console.log(err);
                sendError(res, { msg: err });
              } else {
                const io = req.app.locals.io;
                io.to(uuid).emit("fetch-user");
                res.json();
              }
            }
          );
        })
        .catch((err) => {
          console.log(err);
          sendError(res, { msg: err });
        });
    } else {
      console.log("record not found");
      sendError(res, { msg: "Record not found" });
    }
  });
};

const updateMyRecord = (req, res) => {
  const user_uuid = decodedToken(req).uuid;
  const {
    npi,
    category,
    specialty,
    practice_name,
    medical_license,
    license_state,
    credentials,
    line1,
    city,
    state,
    zip,
  } = req.body;

  const is_patient = req.body.is_patient || false;

  if (
    npi &&
    category &&
    specialty &&
    practice_name &&
    medical_license &&
    license_state &&
    credentials &&
    line1 &&
    city &&
    state &&
    zip
  ) {
    pool.query(queries.getMyRecord, [user_uuid], function (err, results) {
      if (err) return sendError(res, { msg: err });
      createOrUpdate(user_uuid, { line1, city, state, zip, is_patient })
        .then(() => {
          if (results.rows.length > 0) {
            const c = results.rows[0];
            let sent = c.profe_email_sent;
            let pin = c.profe_pin;
            if (!c.profe_email_sent) {
              getAdminFn()
                .then((admin) => {
                  if (admin) {
                    const io = req.app.locals.io;
                    io.to(admin.user_uuid).emit("professional-request");
                    // io.to(userId).emit('fetch-user')
                    sendEmail({
                      to: admin.user_email,
                      html:
                        "<h1>New profile completed -  " +
                        c.user_first_name +
                        " " +
                        c.user_last_name +
                        "</h1><p>A professional has completed Profile II. Please review " +
                        c.user_first_name +
                        "'s account.</p>",
                      subject:
                        "Professional Request - " +
                        c.user_first_name +
                        " " +
                        c.user_last_name,
                    })
                      .then(() => {
                        console.log("Email sent successfully.");
                      })
                      .catch(() => {
                        console.log("Failed to notify admin");
                      });

                    sendEmail({
                      to: c.user_email,
                      html: "<h1>Profile II completed.</h1><p>Your account will be reviewed.</p>",
                      subject: "Thanks for completing profile II.",
                    })
                      .then(() => {
                        console.log("Email sent successfully.");
                      })
                      .catch(() => {
                        console.log("Failed to notify admin");
                      });
                  }
                })
                .catch(() => {
                  console.log("Unable to notify user");
                });
              sent = true;
            }
            pool.query(
              queries.updateMyRecord,
              [
                category,
                npi,
                specialty,
                practice_name,
                medical_license,
                license_state,
                credentials,
                sent,
                user_uuid,
              ],
              (err) => {
                if (err) return sendError(res, { msg: err });
                res.json();
              }
            );
          } else {
            pool.query(
              queries.insert,
              [uuidv4(), category, npi, true, 4609095, user_uuid],
              function (err) {
                if (err) return sendError(res, { msg: err });
                emailStartProfessional(user_uuid);
                res.json();
              }
            );
          }
        })
        .catch((err) => {
          console.log(err);
          sendError(res, { msg: err });
        });
    });
  } else {
    sendError(res, { msg: "Please enter all the data." });
  }
};

const verifyMyPIN = (req, res) => {
  const uuid = decodedToken(req).uuid;
  const { pin } = req.body;

  if (pin && pin.length === 6) {
    pool.query(queries.getMyRecord, [uuid], function (err, result) {
      if (err) {
        sendError(res, { msg: err });
      } else {
        if (result.rows.length > 0) {
          const r = result.rows[0];
          console.log(r);
          if (r["profe_is_active"]) {
            if (r["profe_pin"] === pin) {
              res.json({ success: true });
            } else {
              res.json({ success: false });
            }
          } else {
            res.json({ redirect: true });
          }
        } else {
          res.json({ v: false, ex: false }); // Record does not exists.
        }
      }
    });
  } else {
    sendError(res, { msg: "Please enter a valid PIN code." });
  }
};

const doIHaveAPIN = (req, res) => {
  const uuid = decodedToken(req).uuid;
  pool.query(queries.getMyRecord, [uuid], function (err, results) {
    if (err) {
      console.log(err);
      sendError(res, { msg: err });
    } else {
      if (results.rows.length > 0) {
        const r = results.rows[0];
        if (r["profe_pin"] && r["profe_pin"].length === 6) {
          res.json({ h: true });
        } else {
          res.json({ h: false });
        }
      } else {
        res.json({ h: false });
      }
    }
  });
};

// Reset PIN using email verification.
const resetPIN = (req, res) => {
  const uuid = decodedToken(req).uuid;
  const { pin, verification_code } = req.body;

  if (pin && pin.length) {
    getCode(uuid, false, "PIN")
      .then((data) => {
        if (data && data.veco_code === verification_code) {
          console.log("-> Set new code <-");
          pool.query(
            queries.updateUserPIN,
            [pin, uuid],
            function (err, results) {
              if (err) {
                console.log(err);
                sendError(res, { msg: err });
              } else {
                console.log("---> New pin is set <---");
                deletePreviousCodes(uuid, false, "PIN")
                  .catch(() => {
                    console.log("Failed to delete previous codes.");
                  })
                  .finally(() => {
                    res.json({ valid: true });
                  });
              }
            }
          );
        } else {
          sendError(res, { msg: "The verification code is not valid." });
        }
      })
      .catch((err) => {
        sendError(res, { msg: err });
      });
  }
};

// Set new PIN using the previous PIN
const setNewPIN = (req, res) => {
  const uuid = decodedToken(req).uuid;
  const { previous_pin, new_pin } = req.body;
  if (
    previous_pin &&
    new_pin &&
    previous_pin.length === 6 &&
    new_pin.length === 6
  ) {
    console.log(previous_pin, new_pin);

    pool.query(queries.getMyRecord, [uuid], function (err, results) {
      if (err) {
        sendError(res, { msg: err });
        return 0;
      }
      if (results.rows.length > 0) {
        const r = results.rows[0];
        console.log(r);
        if (r.profe_pin === previous_pin || !r.profe_pin_set) {
          pool.query(
            queries.updateUserPIN,
            [new_pin, uuid],
            function (err, results) {
              if (err) {
                return sendError(res, { msg: err });
              } else {
                res.json();
              }
            }
          );
        } else {
          sendError(res, { msg: "Your current PIN is not correct." });
        }
      } else {
        sendError(res, { msg: "Your record was not found." });
      }
    });
  } else {
    sendError(res, { msg: "Invalid parameters" });
  }
};

module.exports = {
  getAccepted,
  getNotAccepted,
  insert,
  getMyRecord,
  accept,
  updateMyRecord,
  verifyMyPIN,
  doIHaveAPIN,
  resetPIN,
  setNewPIN,
};
