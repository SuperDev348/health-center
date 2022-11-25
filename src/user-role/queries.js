const getRoles = "SELECT * FROM user_role";
const getRoleById = "SELECT * FROM user_role where usro_id = $1";
const getRoleByKey = "SELECT * FROM user_role where UPPER(usro_key) = $1";

module.exports = {
  getRoles,
  getRoleById,
  getRoleByKey,
};
