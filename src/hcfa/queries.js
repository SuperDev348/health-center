const insert =
  "INSERT INTO hcfa (hcfa_uuid, hcfa_patient_id, hcfa_info) VALUES ($1, $2, $3)";

const put =
  "UPDATE hcfa set hcfa_info = $3  where hcfa_patient_id = $2 and hcfa_uuid = $1";

// const getByOwner1 = "SELECT * from hcfa where hcfa_uuid = $1";

// const getPatients = "SELECT * from address where addr_is_patient = false";

const getPatients = "SELECT" + 
	'"user".user_first_name, ' + 
	'"user".user_last_name, ' + 
	'"user".user_uuid ' + 
  "FROM address " + 
  'INNER JOIN "user" ON "user".user_uuid= address.addr_owner ' + 
  "where address.addr_is_patient = false"

const getByOwner = "SELECT " +
"address.addr_city, " + 
"address.addr_line1, " + 
"address.addr_state, " + 
"address.addr_zip, " + 
"address.addr_owner, " + 
'"user".user_first_name, ' + 
'"user".user_last_name, ' + 
'"user".user_phone_no ' + 
"FROM address " + 
'INNER JOIN "user" ON "user".user_uuid= address.addr_owner ' + 
"where address.addr_owner = $1"

const getClaim = "SELECT " +
"hcfa.hcfa_patient_id, " + 
"hcfa.hcfa_info " + 
"FROM hcfa " + 
"where hcfa_uuid = $1 and  hcfa_patient_id = $2"

module.exports = {
  insert,
  put,
  getByOwner,
  getPatients,
  getClaim
};
