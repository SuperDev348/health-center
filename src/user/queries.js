const getUsersBase =
  "SELECT user_uuid, user_email, user_first_name, user_last_name, usro_role, LPAD(user_mrn::text, 3, '0') as mrn, usro_key, user_deleted, user_blocked, user_date_of_birth, user_phone_no, user_country_code  " +
  'FROM "user" INNER JOIN user_role ur on ur.usro_id = "user".user_usro_id ' +
  "WHERE usro_key <> 'SUPER' and user_uuid <> $1";

const getUsersSuper = getUsersBase;
const getUsers = getUsersBase + " and user_deleted = false";
const getMyUsers = getUsers + " and user_owner = $1";

const getModerators =
  "SELECT user_uuid, user_email, user_first_name, user_last_name, usro_role, usro_key, user_deleted, user_blocked from \"user\" INNER JOIN user_role ur on usro_id = user_usro_id WHERE upper(usro_key) = 'MODERATOR'";

const getUserById =
  'SELECT * FROM "user" ' +
  'INNER JOIN user_role ur on ur.usro_id = "user".user_usro_id ' +
  "LEFT JOIN professional on profe_user_uuid = user_uuid " +
  "LEFT JOIN category  on profe_cate_id = cate_id " +
  "LEFT JOIN specialty on profe_spec_id = spec_id " +
  "LEFT JOIN address on addr_owner = user_uuid " +
  "where user_uuid = $1";

const getByEmail =
  'SELECT * FROM "user" INNER JOIN user_role ur on ur.usro_id = "user".user_usro_id where lower(user_email) = $1';

const insertUser =
  'INSERT INTO "user"  (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_owner) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *';

const insertUserWPhone =
  'INSERT INTO "user" (user_uuid, user_email, user_first_name, user_last_name, user_country_code, user_phone_no, user_password, user_usro_id, user_email_verified, user_owner) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *';

const insertVerificationCode =
  'INSERT INTO "verification_code" (veco_code, veco_user_uuid, veco_reset_password) VALUES ($1, $2, $3)';

const deleteVerificationCodes =
  'DELETE FROM "verification_code" where veco_user_uuid = $1 and veco_reset_password = $2';

const getVerificationCode =
  'SELECT * FROM "verification_code" where veco_user_uuid = $1 and veco_reset_password = $2';

const verifyUser =
  'UPDATE "user" set user_email_verified = true where user_uuid = $1';

const updatePassword =
  'UPDATE "user" SET user_password = $1 WHERE user_uuid = $2';

const updateUserDeleted =
  'UPDATE "user" SET user_deleted = $1 WHERE user_uuid = $2';

const updateUserRole =
  'UPDATE "user" SET user_usro_id = $1 where user_uuid = $2 RETURNING *';

const setBlocked = 'UPDATE "user" set user_blocked = $1 WHERE user_uuid = $2';

const getModeratorsFromUser =
  "SELECT *" +
  'from "user" as main_user inner join user_role ur on ur.usro_id = main_user.user_usro_id ' +
  'left join my_professionals on my_professionals.mypr_proffesional = "main_user".user_uuid ' +
  "where usro_key = 'MODERATOR' and (mypr_uuid = $1 or mypr_uuid is null);";

const putUser =
  'UPDATE "user" set user_first_name = $1, user_last_name = $2, user_country_code = $3, user_phone_no = $4 WHERE user_uuid = $5';

let searchUser =
  "SELECT DISTINCT ON (user_uuid) " +
  " cate_category as category, concat_ws(' ', user_first_name, user_last_name) as full_sname, user_first_name, user_last_name, profe_credentials,user_uuid as uuid, user_picture, concat_ws(' | ', LPAD(user_mrn::text, 3, '0'), concat_ws(' ', user_first_name, user_last_name)) full_name, spec_specialty specialty, addr_line1, addr_city, addr_state, addr_zip " +
  'from "user" ' +
  'left join user_role ur on "user".user_usro_id = ur.usro_id ' +
  'left join professional on "user".user_uuid = profe_user_uuid ' +
  "left join category on profe_cate_id = cate_id " +
  "left join address on addr_owner = user_uuid " +
  "left join specialty on profe_spec_id = spec_id " +
  "where upper(usro_key) = $1 " +
  "and (concat_ws(' ', LOWER(user_first_name), LOWER(user_last_name)) like $2 or concat_ws('', '', user_mrn) like $2)";

const searchModeratorInCategory = searchUser + " and profe_cate_id = ANY($3)";

// searchUser = searchUser + " group by user_uuid, cate_category, user_first_name, user_last_name, profe_credentials";

const getByMRN = 'SELECT count(*) as count FROM "user" where user_mrn = $1';

const getAdmin =
  "select user_uuid, concat_ws(' ', user_first_name, user_last_name) as name, usro_key, user_email from \"user\" inner join user_role ur on ur.usro_id = \"user\".user_usro_id where upper(usro_key) = 'ADMIN' LIMIT 1";

const getArchived = getUsersBase + " and user_deleted = true";

const unarchive = 'update "user" set user_deleted = false where user_uuid = $1';

const updatePicture =
  'update "user" set user_picture = $1 where user_uuid = $2';

const getMyPicture = 'SELECT user_picture from "user" where user_uuid = $1';

const practiceAddress =
  'SELECT address.* FROM "user" inner join address on addr_owner = user_uuid where addr_is_patient = false and user_uuid = $1';

module.exports = {
  getUsers,
  getUsersSuper,
  getUserById,
  insertUser,
  getByEmail,
  insertVerificationCode,
  deleteVerificationCodes,
  verifyUser,
  getVerificationCode,
  updatePassword,
  updateUserDeleted,
  updateUserRole,
  getModerators,
  setBlocked,
  getModeratorsFromUser,
  putUser,
  searchUser,
  getByMRN,
  getAdmin,
  getMyUsers,
  searchModeratorInCategory,
  getArchived,
  unarchive,
  updatePicture,
  getMyPicture,
  practiceAddress,
  insertUserWPhone,
};
