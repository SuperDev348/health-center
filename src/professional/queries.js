const insert =
  "INSERT INTO professional (profe_uuid, profe_cate_id, profe_npi, profe_is_active, profe_pin, profe_user_uuid) VALUES ($1, $2, $3, $4, $5, $6)";

const del = "DELETE from professional where profe_uuid = $1";

const accept =
  "UPDATE professional set profe_is_active = true, profe_pin = $1 where profe_user_uuid = $2";

const getNotAccepted =
  'SELECT * FROM professional inner join "user" on user_uuid = profe_user_uuid inner join category on profe_cate_id = cate_id where profe_is_active = false and profe_email_sent = true';

const getAccepted =
  'SELECT * FROM professional inner join "user" on user_uuid = profe_user_uuid  where profe_is_active = true';

const getMyRecord =
  'SELECT * FROM professional inner join "user" on profe_user_uuid = user_uuid where profe_user_uuid = $1';

const getRecord = "SELECT * FROM professional where profe_uuid = $1";

const updateMyRecord =
  "UPDATE professional set profe_cate_id = $1, profe_npi = $2, profe_spec_id = $3, profe_practice_name = $4, profe_medical_license = $5, profe_license_state = $6, profe_credentials = $7, profe_email_sent = $8 where profe_user_uuid = $9";

const updateUserPIN =
  "UPDATE professional set profe_pin = $1, profe_pin_set = true where profe_user_uuid = $2";

module.exports = {
  insert,
  del,
  accept,
  getNotAccepted,
  getAccepted,
  getMyRecord,
  getRecord,
  updateMyRecord,
  updateUserPIN,
};
