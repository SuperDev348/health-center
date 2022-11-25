const fs = require("fs");
const path = require("path");
const { validationResult } = require("express-validator");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
const { v4: uuidv4 } = require("uuid");

function hasAuthorization(req) {
  return !!req.headers.authorization;
}

function isAuthorized(req) {
  let rv = false;
  if (hasAuthorization(req)) {
    try {
      jwt.verify(getToken(req), process.env.TOKEN_SECRET);
      rv = true;
    } catch {
      rv = false;
    }
  } else {
    rv = false;
  }
  return rv;
}

function getToken(req) {
  return req.headers.authorization.split(" ")[1];
}
function decodedToken(req) {
  return jwt.decode(getToken(req));
}

function isAdmin(req) {
  const token = decodedToken(req);
  return token && token.role && token.role.toUpperCase() === "ADMIN";
}

function isModerator(req) {
  const token = decodedToken(req);
  return token && token.role && token.role.toUpperCase() === "MODERATOR";
}

function isSuper(req) {
  const token = decodedToken(req);
  return token && token.role && token.role.toUpperCase() === "SUPER";
}

function isSuperOrAdmin(req) {
  return isAdmin(req) || isSuper(req);
}

function checkValidationError(req) {
  return new Promise((resolve, reject) => {
    const errors = validationResult(req);
    if (errors.isEmpty()) {
      resolve();
    } else {
      reject(errors.array());
    }
  });
}
function capitalizeFirstLetter(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}

function sError(res, err) {
  sendError(res, { msg: err });
}

function sendError(res, options) {
  const code = options && options.code ? options.code : 400;

  let message = options && options.msg ? options.msg : null;
  let fm = "Unknown error";

  if (message !== null && message !== undefined) {
    if (
      message.length &&
      typeof message[0] === "object" &&
      message[0].msg &&
      message[0].param
    ) {
      fm = message[0].msg;
    } else if (typeof message === "string") {
      fm = message;
    } else if (typeof message === "object") {
      if (message.code && message.severity) {
        fm = message.severity + " - " + message.code;
      } else if (message.msg) {
        fm = message.msg;
      } else if (message.message) {
        fm = message.message;
      }
    }
  }
  if (!res.headersSent) {
    if (res) {
      res.status(code).json({ msg: fm });
    }
  }
}

// async..await is not allowed in global scope, must use a wrapper
async function sendEmail(options) {
  const defaultOptions = {
    host: process.env.SMTP_HOST,
    user: process.env.SMTP_EMAIL,
    password: process.env.SMTP_PASSWORD,
    port: process.env.SMTP_PORT,
    from: "Mednoor <" + process.env.SMTP_EMAIL + ">",
    to: "",
    subject: "",
    html: "<p>If you are seeing this message, delete this email. This is likely an error</p>",
    attachments: [],
  };

  if (options) {
    const keys = Object.keys(options);
    keys.forEach((key) => {
      defaultOptions[key] = options[key];
    });
  }

  // create reusable transporter object using the default SMTP transport
  let transporter = nodemailer.createTransport({
    host: defaultOptions.host,
    port: defaultOptions.port,
    secure: defaultOptions.port === "465", // true for 465, false for other ports
    auth: {
      user: defaultOptions.user, // generated ethereal user
      pass: defaultOptions.password, // generated ethereal password
    },
    debug: false, // show debug output
    logger: true,
  });

  transporter.verify(function (error, success) {
    if (error) {
      console.log(error);
    } else {
      console.log("Server is ready to take our messages");
    }
  });

  // send mail with defined transport object
  let info = await transporter.sendMail({
    from: defaultOptions.from, // sender address
    to: defaultOptions.to, // list of receivers
    subject: defaultOptions.subject, // Subject line
    html: defaultOptions.html, // html body
    attachments: defaultOptions.attachments,
    secure: defaultOptions.port === "465",
    debug: false,
  });
  return info.messageId;
}

function createIfNotExists(p) {
  console.log(`!fs.existsSync(${p})`);
  console.log("Exists?", fs.existsSync(p));
  console.log(fs.mkdirSync);
  console.log(p, typeof p);
  console.log(path.join(p), typeof path.join(p));

  if (!fs.existsSync(p)) {
    fs.mkdirSync(path.join(p), {
      recursive: true,
    });
  }
}

function uploadFile(file, options) {
  options = options || {};
  file = file || null;
  const opts = {
    generateName: true,
    name: "",
    uploadPath: "/upload/mixed/",
  };
  Object.keys(options).forEach((key) => {
    opts[key] = options[key];
  });
  return new Promise((resolve, reject) => {
    if (file) {
      let finalName = "";
      if (opts.generateName) {
        finalName = uuidv4() + path.extname(file.name);
      } else {
        finalName = opts.name;
      }
      file
        .mv(path.join(opts.uploadPath, finalName))
        .then(async (dm, e) => {
          resolve(finalName);
        })
        .catch((e) => {
          reject(e);
        });
    } else {
      reject(new Error("Missing parameter: File"));
    }
  });
}

function deleteIfExists(filePath) {
  if (fs.existsSync(filePath)) {
    fs.unlinkSync(filePath);
  }
}

function generateRandomNDigits(n) {
  const c = Math.floor(100000 + Math.random() * 900000000).toString();
  if (c.length === n) {
    return c;
  } else {
    return generateRandomNDigits(n);
  }
}

function getIpAddress(req) {
  return req.headers["x-forwarded-for"] || req.socket.remoteAddress || null;
}

module.exports = {
  sendError,
  checkValidationError,
  sendEmail,
  decodedToken,
  getToken,
  createIfNotExists,
  uploadFile,
  deleteIfExists,
  isAuthorized,
  isAdmin,
  isModerator,
  hasAuthorization,
  generateRandomNDigits,
  getIpAddress,
  sError,
};
