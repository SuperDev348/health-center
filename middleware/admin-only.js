const { decodedToken, isAdmin } = require("../utils");
module.exports = (req, res, next) => {
  if (isAdmin(req)) {
    next();
  } else {
    res.status(401).json({ error: "Unauthorized" });
  }
};
