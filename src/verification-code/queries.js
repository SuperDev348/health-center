const insertVerificationCode =
  'INSERT INTO "verification_code" (veco_code, veco_user_uuid, veco_reset_password, veco_type) VALUES ($1, $2, $3, $4)';

const deleteVerificationCodes =
  'DELETE FROM "verification_code" where veco_user_uuid = $1 and veco_reset_password = $2 and UPPER(veco_type) = $3';

const getVerificationCode =
  'SELECT * FROM "verification_code" where veco_user_uuid = $1 and veco_reset_password = $2 AND UPPER(veco_type) = $3';


module.exports = {
  insertVerificationCode,
  deleteVerificationCodes,
  getVerificationCode
}