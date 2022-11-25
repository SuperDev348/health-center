const pool = require("../../db");
const queries = require("./queries");
const userRoleQueries = require("../user-role/queries");

const { v4: uuidv4, validate: isValidUUID } = require("uuid");
const {
  sendError,
  checkValidationError,
  decodedToken,
  sendEmail,
  isAuthorized,
  isAdmin,
  isModerator,
  generateRandomNDigits,
  uploadFile,
  deleteIfExists,
  getIpAddress,
  sError,
} = require("../../utils");

const { getRoleByKey } = require("../user-role/controller");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const { createOrUpdate } = require("../address/controller");
const {
  insert: insertRefreshToken,
  del: deleteRefreshToken,
  get: getRefreshToken,
  delById: deleteRefreshTokenById,
} = require("../refresh-token/controller");

const getUsers = (req, res) => {
  checkValidationError(req)
    .then(() => {
      const token = decodedToken(req);
      let query =
        token.role.toUpperCase() === "SUPER"
          ? queries.getUsersSuper
          : queries.getUsers;

      let params = [token.uuid];

      const rq = req.query;

      if (rq.view) {
        const view = rq.view.toLowerCase();
        if (view === "users") {
          if (isAuthorized(req) && !isAdmin(req)) {
            query = queries.getMyUsers;
          } else {
            query = queries.getUsers;
          }
        } else if (view === "professionals") {
          query = queries.getModerators;
          params = null;
        } else if (view === "archived") {
          query = queries.getArchived;
        }
      }

      pool.query(query, params, (error, results) => {
        if (error) {
          sendError(res, { msg: error });
        } else {
          res.json(results.rows);
        }
      });
    })
    .catch((err) => {
      sendEmail(res, { msg: err });
    });
};

const getUserById = (req, res) => {
  const id = req.params.id;
  pool.query(queries.getUserById, [id], (error, results) => {
    if (error) {
      sendError(res, { msg: error });
    } else {
      if (results.rows.length > 0) {
        const r = results.rows[0];
        delete r.user_password; // Hide user password hash because that could lead to a brute force attack.
        res.json(r);
      } else {
        res.json();
      }
    }
  });
};

async function getUserByEmail(email) {
  let r = [];
  await pool
    .query(queries.getByEmail, [email.toLowerCase()])
    .then((results) => {
      r = results.rows;
    })
    .catch(() => {
      r = [];
    });
  return r;
}

async function emailExists(email) {
  return (await getUserByEmail(email)).length > 0;
}

function generateToken(user, tokenId) {
  let tokenInfo;
  if (user && user.length && user.length > 0) {
    const usr = user[0];
    tokenInfo = { uuid: usr.user_uuid };
    tokenInfo.tokenId = tokenId;
    if (usr.usro_key) {
      tokenInfo.role = usr.usro_key;
    }
    if (usr.user_first_name) {
      tokenInfo.user_first_name = usr.user_first_name;
    }
    if (usr.user_last_name) {
      tokenInfo.last_name = usr.user_last_name;
    }
    try {
      tokenInfo.verified = usr.user_email_verified;
    } catch {
      tokenInfo.verified = false;
    }
    if (usr.usro_role) {
      tokenInfo.roleTxt = usr.usro_role;
    }
    if (usr.user_email) {
      tokenInfo.email = usr.user_email;
    }
  } else {
    tokenInfo = {
      uuid: null,
    };
  }
  return jwt.sign(tokenInfo, process.env.TOKEN_SECRET);
}

function createHashedPassword(plainTextPassword) {
  return new Promise(async (resolve, reject) => {
    await bcrypt
      .genSalt(10)
      .then(async (salt) => {
        await bcrypt
          .hash(plainTextPassword, salt)
          .then(async (hashedPassword) => {
            resolve(hashedPassword);
          })
          .catch((e) => {
            reject(e);
          });
      })
      .catch((e) => {
        reject(e);
      });
  });
}

function mrnExists(mrn) {
  return new Promise((resolve) => {
    pool.query(queries.getByMRN, [mrn], function (err, results) {
      if (err) {
        resolve(true);
      } else {
        if (results.rows && results.rows.length > 0) {
          const d = results.rows[0];
          resolve(d.count > 0);
        }
      }
    });
  });
}

const insertUser = (req, res) => {
  checkValidationError(req)
    .then(async () => {
      const {
        email,
        first_name,
        last_name,
        dob,
        password,
        confirm_password,
        country_code,
        phone_no,
      } = req.body;
      if (await emailExists(email)) {
        sendError(res, { msg: "The email already exists" });
      } else {
        const role = await getRoleByKey("USER");
        if (role && role.length && role[0].usro_id) {
          createHashedPassword(password)
            .then((hashedPassword) => {
              let isVerified = false;

              if (isAuthorized(req)) {
                isVerified = isAdmin(req) || isModerator(req);
              }
              let owner = null;

              if (isAuthorized(req)) {
                owner = decodedToken(req).uuid;
              }

              const data = [
                uuidv4(),
                email,
                first_name,
                last_name,
                country_code.replace("+", ""),
                phone_no,
                hashedPassword,
                role[0].usro_id,
                isVerified,
                owner,
              ];
              const query = queries.insertUserWPhone;
              pool.query(query, data, (error, results) => {
                if (error) {
                  sendError(res, { msg: error });
                } else {
                  if (isVerified) {
                    res.json(results.rows);
                  } else {
                    sendVerificationCode(results.rows[0].user_uuid, email)
                      .then(async () => {
                        res.json(results.rows);
                      })
                      .catch(() => {
                        res.json();
                      });
                  }
                }
              });
            })
            .catch((e) => {
              sendError(res, { msg: e });
            });
        } else {
          sendError(res, { code: 500, msg: "Internal server error." }); // There is no data in user_role table. (Fill it)
        }
      }
    })
    .catch((error) => {
      sendError(res, { msg: error });
    });
};

async function verifyPassword(hashedPassword, plainTextPassword) {
  return new Promise((resolve) => {
    bcrypt
      .compare(plainTextPassword, hashedPassword)
      .then((validPass) => {
        resolve(validPass);
      })
      .catch(() => {
        resolve(false);
      });
  });
}

function sendVerificationCode(user_uuid, email, isResetPassword) {
  return new Promise((resolve, reject) => {
    const code = generateRandomNDigits(9);
    isResetPassword = isResetPassword || false;
    pool
      .query(queries.deleteVerificationCodes, [user_uuid, isResetPassword])
      .catch((e) => console.log("Failed to delete old verification codes", e))
      .finally(() => {
        pool
          .query(queries.insertVerificationCode, [
            code,
            user_uuid,
            isResetPassword,
          ])
          .then(async () => {
            await sendEmail({
              to: email,
              html:
                "<h1>Welcome to Mednoor</h1><p>Thanks for signing up to mednoor</p><p>Your verification code is <b>" +
                code +
                "</b></p>",
              subject: isResetPassword
                ? "Reset your password"
                : "Verification Code",
            })
              .then(() => {
                resolve(code);
              })
              .catch((e) => {
                reject(e);
              });
          })
          .catch((e) => {
            reject(e);
          });
      });
  });
}

const signIn = (req, res) => {
  checkValidationError(req)
    .then(async () => {
      const { email, password } = req.body;

      const user = await getUserByEmail(email);

      if (user && user.length && user.length > 0) {
        verifyPassword(user[0].user_password, password)
          .then((isValid) => {
            if (isValid) {
              const tokenId = uuidv4();
              const token = generateToken(user, tokenId);
              insertRefreshToken(tokenId, user[0].user_uuid, getIpAddress(req))
                .then((refresh_token) => {
                  res.json({ valid: true, token: token, refresh_token });
                })
                .catch((err) => {
                  sendError(res, { msg: err });
                });
            } else {
              sendError(res, { msg: "Incorrect password" });
            }
          })
          .catch((e) => {
            sendError(res, { msg: e });
          });
      } else {
        sendError(res, { msg: "The email does not exist" });
      }
    })
    .catch((e) => {
      sendError(res, { msg: e });
    });
};

const me = (req, res) => {
  checkValidationError(req)
    .then(() => {
      const info = decodedToken(req);
      pool.query(queries.getUserById, [info.uuid], function (err, results) {
        if (err) {
          sendError(res, { msg: err });
        } else {
          if (results.rows && results.rows.length > 0) {
            const u = results.rows[0];
            info.verified = u.user_email_verified;
            info.user_first_name = u.user_first_name;
            info.last_name = u.user_last_name;
            info.blocked = u.user_blocked;
            info.role = u.usro_key;
            info.deleted = u.user_deleted;
            info.picture = u.user_picture;
            info.credentials = u.profe_credentials;
            info.has_phone = !!u.user_phone_no;
          }
          res.json({ user: info });
        }
      });
    })
    .catch((e) => {
      sendError(res, { msg: e });
    });
};

const verify = (req, res) => {
  checkValidationError(req)
    .then(async () => {
      const { code, email } = req.body;
      const uuid = decodedToken(req).uuid;
      if (uuid) {
        pool.query(
          queries.getVerificationCode,
          [uuid, false],
          async function (error, results) {
            if (error) {
              sendError(res, { msg: error });
            } else {
              if (results.rows && results.rows.length > 0) {
                const r = results.rows[0];
                if (r && r.veco_code && r.veco_code === code) {
                  await pool.query(
                    queries.verifyUser,
                    [uuid],
                    function (error, results) {
                      if (error) {
                        console.log("Error while trying to verifyUser");
                      }
                    }
                  );
                  await pool.query(
                    queries.deleteVerificationCodes,
                    [uuid, false], // false --> Not deleting verification codes for password reset.
                    function (error, results) {
                      if (error) {
                        console.log("Error while trying to verifyUser");
                      }
                    }
                  );
                  res.json({});
                } else {
                  sendError(res, { msg: "Incorrect verification code" });
                }
              } else {
                sendError(res, { msg: "Verification code not found" });
              }
            }
          }
        );
      } else {
        sendError(res, { msg: "User not found" });
      }
    })
    .catch((e) => {
      sendError(res, { msg: e });
    });
};

const verifyPwdCode = (req, res) => {
  checkValidationError(req)
    .then(() => {
      const { code, email } = req.body;
      let uuid;
      pool.query(
        queries.getByEmail,
        [email.toLowerCase()],
        function (err, results) {
          if (err) {
            sendError(res, { msg: "The user was not found." });
          } else {
            if (results.rows && results.rows.length > 0) {
              uuid = results.rows[0].user_uuid;
              pool.query(
                queries.getVerificationCode,
                [uuid, true],
                async function (error, results) {
                  if (error) {
                    sendError(res, { msg: error });
                  } else {
                    if (results.rows && results.rows.length > 0) {
                      const r = results.rows[0];
                      if (r && r.veco_code && r.veco_code === code) {
                        res.json({ success: true });
                      } else {
                        sendError(res, { msg: "Incorrect verification code" });
                      }
                    } else {
                      sendError(res, { msg: "Verification code not found" });
                    }
                  }
                }
              );
            }
          }
        }
      );
    })
    .catch((e) => {
      sendError(res, { msg: e });
    });
};

const forgotPassword = (req, res) => {
  checkValidationError(req)
    .then(() => {
      const { email } = req.body;
      pool.query(
        queries.getByEmail,
        [email.toLowerCase()],
        function (err, results) {
          if (err) {
            sendError(res, { msg: err });
          } else {
            if (results.rows && results.rows.length > 0) {
              const u = results.rows[0];
              sendVerificationCode(u.user_uuid, u.user_email, true)
                .then(async (code) => {
                  res.json();
                })
                .catch((e) => {
                  sendError(res, { msg: "Could not send verification code." });
                });
            } else {
              sendError(res, { msg: "The email was not found." });
            }
          }
        }
      );
    })
    .catch((e) => {
      sendError(res, { msg: e });
    });
};

const resetPassword = (req, res) => {
  checkValidationError(req)
    .then(() => {
      const { email, password, code } = req.body;
      pool.query(
        queries.getByEmail,
        [email.toLowerCase()],
        function (err, results) {
          if (err) {
            sendError(res, { msg: "The user was not found." });
          } else {
            if (results.rows && results.rows.length > 0) {
              let uuid = results.rows[0].user_uuid;
              pool.query(
                queries.getVerificationCode,
                [uuid, true],
                async function (error, results) {
                  if (error) {
                    sendError(res, { msg: error });
                  } else {
                    if (results.rows && results.rows.length > 0) {
                      const r = results.rows[0];
                      if (r && r.veco_code && r.veco_code === code) {
                        createHashedPassword(password)
                          .then((hashedPassword) => {
                            pool.query(
                              queries.updatePassword,
                              [hashedPassword, uuid],
                              function (err, results) {
                                if (err) {
                                  sendError(res, { msg: err });
                                } else {
                                  pool.query(
                                    queries.deleteVerificationCodes,
                                    [uuid, true],
                                    function (e, r) {
                                      res.json();
                                    }
                                  );
                                }
                              }
                            );
                          })
                          .catch((e) => {
                            sendError(res, { msg: e });
                          });
                      } else {
                        sendError(res, { msg: "Incorrect verification code" });
                      }
                    } else {
                      sendError(res, { msg: "Verification code not found" });
                    }
                  }
                }
              );
            }
          }
        }
      );
    })
    .catch((e) => {
      sendError(res, { msg: e });
    });
};

const changePassword = (req, res) => {
  checkValidationError(req)
    .then(() => {
      const { old_password, password, confirm_password } = req.body;
      const userId = decodedToken(req).uuid;
      if (userId) {
        if (old_password && password && confirm_password) {
          if (password === confirm_password) {
            pool.query(queries.getUserById, [userId], function (err, results) {
              if (err) {
                sendError(res, { msg: err });
              } else {
                if (results && results.rows && results.rows.length > 0) {
                  const user = results.rows[0];
                  verifyPassword(user.user_password, old_password).then(
                    (valid) => {
                      if (valid) {
                        createHashedPassword(password)
                          .then((hashedPassword) => {
                            pool
                              .query(queries.updatePassword, [
                                hashedPassword,
                                userId,
                              ])
                              .then(() => {
                                res.json();
                              })
                              .catch((err) => {
                                sendError(res, { msg: err });
                              });
                            res.json({ hashedPassword });
                          })
                          .catch((err) => {
                            sendError(res, { msg: err });
                          });
                      } else {
                        sendError(res, {
                          msg: "The old password is incorrect",
                        });
                      }
                    }
                  );
                } else {
                  sendError(res, { msg: err });
                }
              }
            });
          } else {
            sendError(res, {
              msg: "Confirm password and password must be equal.",
            });
          }
        } else {
          sendError(res, { msg: "Missing parameters" });
        }
      } else {
        sendError(res, { msg: "Server Error" });
      }
    })
    .catch((e) => {
      sendError(res, { msg: e });
    });
};

const updateUserDeleted = (req, res) => {
  checkValidationError(req)
    .then(() => {
      const uuid = req.params.id;
      pool.query(
        queries.updateUserDeleted,
        [true, uuid],
        function (err, results) {
          if (err) {
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
      sendError(res, { msg: err });
    });
};

const updateToProfessional = (uuid) => {
  return new Promise((resolve, reject) => {
    pool.query(
      userRoleQueries.getRoleByKey,
      ["MODERATOR"],
      function (err, results) {
        if (err) {
          reject(err);
        } else {
          if (results && results.rows && results.rows.length) {
            const role = results.rows[0];
            const roleId = role.usro_id;
            pool.query(
              queries.updateUserRole,
              [roleId, uuid],
              function (err, results) {
                if (err) {
                  reject(err);
                } else {
                  resolve();
                }
              }
            );
          } else {
            reject("User role not found");
          }
        }
      }
    );
  });
};

const updateUserRole = (req, res) => {
  checkValidationError(req)
    .then(() => {
      let { key } = req.body;
      key = key.toUpperCase();
      const uuid = req.params.id;

      pool.query(userRoleQueries.getRoleByKey, [key], function (err, results) {
        if (err) {
          sendError(res, { msg: err });
        } else {
          if (results && results.rows && results.rows.length) {
            const role = results.rows[0];
            const roleId = role.usro_id;
            pool.query(queries.updateUserRole, [roleId, uuid], function (err) {
              if (err) {
                sendError(res, { msg: err });
              } else {
                //send new role info
                const io = req.app.locals.io;
                io.to(uuid).emit("fetch-user");
                res.json(role);
              }
            });
          } else {
            sendError(res, { msg: "User role not found" });
          }
        }
      });
    })
    .catch((err) => {
      sendError(res, { msg: err });
    });
};

const getModerators = (req, res) => {
  checkValidationError(req)
    .then(() => {
      pool.query(queries.getModerators, function (err, r) {
        if (err) {
          sendError(res, { msg: err });
        } else {
          res.json(r.rows);
        }
      });
    })
    .catch((err) => {
      sendError(res, { msg: err });
    });
};

const getModeratorsFromUser = (req, res) => {
  checkValidationError(req)
    .then(() => {
      const uuid = req.params.id;
      pool.query(queries.getModeratorsFromUser, [uuid], function (err, r) {
        if (err) {
          sendError(res, { msg: err });
        } else {
          res.json(r.rows);
        }
      });
    })
    .catch((err) => {
      sendError(res, { msg: err });
    });
};

const updateBlocked = (req, res) => {
  checkValidationError(req)
    .then(() => {
      const uuid = req.params.id;
      const { blocked } = req.body;
      pool.query(queries.setBlocked, [blocked, uuid], function (err, result) {
        if (err) {
          sendError(res, { msg: err });
        } else {
          const io = req.app.locals.io;
          io.to(uuid).emit("fetch-user");
          res.json();
        }
      });
    })
    .catch((err) => {
      sendError(res, { msg: err });
    });
};

function updateUserData(data, res) {
  pool.query(
    queries.putUser,
    [
      data.first_name,
      data.last_name,
      data.country_code ? data.country_code.replace("+", "") : "",
      data.phone_no,
      data.uuid,
    ],
    function (err) {
      if (err) {
        sendError(res, { msg: err });
      } else {
        res.json();
      }
    }
  );
  res.json(data);
}

const putUser = (req, res) => {
  checkValidationError(req)
    .then(() => {
      const data = req.body;
      const uuid = decodedToken(req).uuid;

      data.uuid = uuid;

      const { line1, city, state, zip, is_patient } = data;

      if (is_patient) {
        if (line1 && city && state && zip) {
          createOrUpdate(uuid, {
            line1,
            city,
            state,
            zip,
            is_patient,
          })
            .then(() => {
              updateUserData(data, res);
            })
            .catch((err) => {
              sendError(res, { msg: err });
            });
        } else {
          sendError(res, { msg: "Please fill all the address fields." });
        }
      } else {
        updateUserData(data, res);
      }
    })
    .catch((err) => {
      sendError(res, { msg: err });
    });
};

const searchUser = (req, res) => {
  const q = req.query;

  if (q && q.searchTerm !== undefined) {
    const type = q.type;
    let query = queries.searchUser;
    let isnum = /^\d+$/.test(q.searchTerm);
    let searchStr;

    if (isnum) {
      searchStr = parseInt(q.searchTerm) + "%";
    } else {
      searchStr = "%" + q.searchTerm.toLowerCase() + "%";
    }

    let role = "USER";
    if ((q.type && q.type === "MODERATOR") || q.type === "USER") {
      role = q.type;
    }

    const categories = q.categories || [];
    const queryData = [role, searchStr.toString()];

    if (role === "MODERATOR" && categories && categories.length) {
      query = queries.searchModeratorInCategory;
      queryData.push(categories);
    }

    pool.query(query, queryData, function (err, results) {
      if (err) {
        sendError(res, { msg: err });
      } else {
        res.json(results.rows);
      }
    });
  } else {
    sendError(res, { msg: "No search term was provided" });
  }
};

const getAdminFn = () => {
  return new Promise((resolve, reject) => {
    pool.query(queries.getAdmin, function (err, results) {
      if (err) {
        reject(err);
      } else {
        if (results.rows.length > 0) {
          resolve(results.rows[0]);
        } else {
          resolve({});
        }
      }
    });
  });
};

const getAdmin = (req, res) => {
  getAdminFn()
    .then((r) => {
      res.json(r);
    })
    .catch((err) => {
      sendError(res, { msg: err });
    });
};

const temporalUser = async (req, res) => {
  const { first_name } = req.body;
  const names = first_name.split(" ");
  if (names.length >= 2) {
    const role = await getRoleByKey("USER");
    if (role && role.length && role[0].usro_id) {
      pool.query(
        queries.insertUser,
        [
          uuidv4(),
          null, // email
          names[0],
          names[1],
          null,
          null,
          role[0].usro_id,
          false,
          null,
        ],
        function (err, results) {
          if (err) {
            sendError(res, { msg: err });
          } else {
            res.json(results.rows[0]);
          }
        }
      );
    } else {
      sendError(res, { code: 500, msg: "Internal server error" });
    }
  } else {
    sendError(res, { msg: "Enter your First name and Last Name" });
  }
};

const isGuest = (uuid) => {
  return new Promise((resolve) => {
    pool.query(queries.getUserById, [uuid], function (err, result) {
      if (err) {
        resolve(false);
      } else {
        if (result.rows.length > 0) {
          const u = result.rows[0];
          resolve(u.user_email === null);
        } else {
          resolve(false);
        }
      }
    });
  });
};

const updatePicture = (req, res) => {
  const userUUID = decodedToken(req).uuid;
  const uploadPath = "upload/profile";

  pool.query(queries.getMyPicture, [userUUID], function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      let current = "";
      if (results.rows.length > 0) {
        current = results.rows[0].user_picture;
        deleteIfExists(uploadPath + "/" + current);
      }
      uploadFile(req.files.file, {
        uploadPath: uploadPath,
        generateName: true,
      })
        .then((fName) => {
          pool.query(queries.updatePicture, [fName, userUUID], function (err) {
            if (err) {
              sendError(res, { msg: err });
            } else {
              res.json({ file: fName });
            }
          });
        })
        .catch((err) => {
          sendError(res, { msg: err });
        });
    }
  });
};

const unarchive = (req, res) => {
  const uuid = req.params.uuid;
  pool.query(queries.unarchive, [uuid], function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json();
    }
  });
};

const refresh = (req, res) => {
  const { refresh_token } = req.body;
  if (refresh_token && isValidUUID(refresh_token)) {
    getRefreshToken(refresh_token, getIpAddress(req))
      .then((data) => {
        pool.query(
          queries.getUserById,
          [data.reto_user_uuid],
          function (err, results) {
            if (err) {
              sendError(res, { msg: err });
            } else {
              const rows = results.rows;
              if (rows.length > 0) {
                const user = rows[0];

                const tokenId = uuidv4();
                const token = generateToken([user], tokenId);

                insertRefreshToken(tokenId, user.user_uuid, getIpAddress(req))
                  .then((new_refresh_token) => {
                    deleteRefreshToken(refresh_token)
                      .then(() => {
                        res.json({
                          token,
                          refresh_token: new_refresh_token,
                          valid: true,
                        });
                      })
                      .catch((err) => {
                        sendError(res, { msg: err });
                      });
                  })
                  .catch((err) => {
                    sendError(res, { msg: err });
                  });
              } else {
                sendError(res, { msg: "User Not found" });
              }
            }
          }
        );
      })
      .catch((err) => {
        sendError(res, { msg: err });
      });
  } else {
    sendError(res, { msg: "Invalid token" });
  }
};

const logout = (req, res) => {
  const tokenInfo = decodedToken(req);
  const tokenId = tokenInfo.tokenId || null;

  if (tokenId && isValidUUID(tokenId)) {
    deleteRefreshTokenById(tokenId)
      .then(() => {
        res.json();
      })
      .catch((err) => {
        sendError(res, { msg: err });
      });
  } else {
    sendError(res, { msg: "No valid token" });
  }
};

const practiceAddress = (req, res) => {
  const uuid = req.params.uuid;

  pool.query(queries.practiceAddress, [uuid], function (err, results) {
    if (err) return sError(res, err);
    const r = results.rows;
    if (r.length > 0) {
      res.json(results.rows[0]);
    } else {
      res.json();
    }
  });
};

module.exports = {
  getUsers,
  getUserById,
  insertUser,
  signIn,
  me,
  verify,
  verifyPwdCode,
  forgotPassword,
  resetPassword,
  updateUserDeleted,
  updateUserRole,
  getModerators,
  updateBlocked,
  getModeratorsFromUser,
  changePassword,
  putUser,
  searchUser,
  getAdmin,
  getAdminFn,
  temporalUser,
  isGuest,
  updateToProfessional,
  unarchive,
  updatePicture,
  refresh,
  logout,
  practiceAddress,
};
