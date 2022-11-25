const insert =
  "INSERT INTO address (addr_uuid, addr_line1, addr_city, addr_state, addr_zip, addr_owner,addr_is_patient) VALUES ($1, $2, $3, $4, $5, $6, $7)";

const put =
  "UPDATE address set addr_line1 = $1, addr_city = $2, addr_state = $3, addr_zip = $4 WHERE addr_owner = $5 and addr_is_patient = $6";

const getByOwner = "SELECT * from address where addr_owner = $1";

const getByOwnerNType =
  "SELECT * from address where addr_owner = $1 and addr_is_patient = $2";

module.exports = {
  insert,
  put,
  getByOwner,
  getByOwnerNType,
};
