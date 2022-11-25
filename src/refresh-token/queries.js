const getByRefreshToken =
  "SELECT * from refresh_token where reto_refresh_token = $1";

const insert =
  "INSERT into refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_ip_address) VALUES ($1, $2, $3, $4)";

const delByRefreshToken =
  "delete from refresh_token where reto_refresh_token = $1";

const delById = "delete from refresh_token where reto_uuid = $1";

module.exports = {
  getByRefreshToken,
  insert,
  delByRefreshToken,
  delById,
};
