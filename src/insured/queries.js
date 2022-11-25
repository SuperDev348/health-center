const insert =
  "INSERT INTO insured (user_uuid, insured_info) VALUES ($1, $2)";

const put =
  "UPDATE insured set insured_info = $2  where user_uuid = $1";

const getRecord = "SELECT * from insured where user_uuid = $1";

module.exports = {
  insert,
  put,
  getRecord,
};
