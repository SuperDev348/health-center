const insert =
  "INSERT INTO claims (user_uuid, claims_info) VALUES ($1, $2)";

const put =
  "UPDATE claims set claims_info = $2  where user_uuid = $1";

const getRecord = "SELECT * from claims where user_uuid = $1";

module.exports = {
  insert,
  put,
  getRecord,
};
