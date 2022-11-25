const jwt = require("jsonwebtoken");
const { getToken, hasAuthorization } = require("../utils");

module.exports = (req, res, next) => {
  try {
    if (!hasAuthorization(req)) {
      throw new Error();
    }
    jwt.verify(getToken(req), process.env.TOKEN_SECRET);
    next();
  } catch (e) {
    res.status(401).json({ msg: "Unauthorized" });
  }
};
