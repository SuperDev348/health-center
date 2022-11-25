const addMyProfessional =
  'INSERT INTO "my_professionals" (mypr_uuid, mypr_proffesional) VALUES ($1, $2)';

const professionalExists =
  "SELECT * FROM my_professionals where mypr_uuid = $1 and mypr_proffesional = $2";

const getMyProfessionals =
  "SELECT main_user.user_uuid,main_user.user_first_name, main_user.user_last_name, main_user.user_picture, profe_credentials " +
  'from "user" as main_user inner join user_role ur on ur.usro_id = main_user.user_usro_id ' +
  '        inner join my_professionals on my_professionals.mypr_proffesional = "main_user".user_uuid ' +
  " INNER JOIN professional on user_uuid = profe_user_uuid " +
  "        where usro_key = 'MODERATOR'" +
  "        and (mypr_uuid = $1) and mypr_allowed = true";

const getMyProfessionalsIds =
  "SELECT mypr_proffesional as professional from my_professionals where mypr_uuid = $1";

// 1 is the professional and 2 is the user
const getProfessionals =
  'SELECT u.user_first_name as fn1, u.user_last_name as ln1, u2.user_first_name as fn2, u2.user_last_name ln2, mypr_id, mypr_allowed FROM my_professionals inner join "user" u on u.user_uuid = my_professionals.mypr_proffesional inner join "user" u2 on u2.user_uuid = my_professionals.mypr_uuid;';

// A professional can get his assigned users
const getMyUsers =
  'SELECT u.*, u2.*, mypr_uuid, mypr_allowed, mypr_id from my_professionals INNER JOIN "user" u on u.user_uuid = my_professionals.mypr_proffesional INNER JOIN "user" u2 on u2.user_uuid = my_professionals.mypr_uuid where mypr_proffesional = $1 and mypr_allowed = true';

const getNotAcceptedUsers =
  'SELECT user_uuid, user_first_name, user_last_name, mypr_allowed, mypr_uuid, mypr_allowed, mypr_id, mypr_date from my_professionals INNER JOIN "user" on user_uuid = my_professionals.mypr_uuid where mypr_proffesional = $1 and mypr_allowed = false';

const setAllowed =
  "UPDATE my_professionals SET mypr_allowed = $1 WHERE mypr_id = $2 RETURNING *";

const deleteConversationWithParticipants =
  "DELETE FROM conversation where conv_user_a = $1 and conv_user_b = $2 or conv_user_a = $2 and conv_user_b = $1";

const deleteMyProfessional =
  "DELETE FROM my_professionals where mypr_uuid = $1 and mypr_proffesional = $2 or mypr_uuid = $2 and mypr_proffesional = $1";

const insertOldConversation =
  "insert into previous_conversation (prco_uuid, prco_user_a, prco_user_b, prco_pdf) VALUES ($1, $2, $3, $4)";

module.exports = {
  addMyProfessional,
  getMyProfessionals,
  getProfessionals,
  getMyUsers,
  setAllowed,
  getNotAcceptedUsers,
  deleteConversationWithParticipants,
  insertOldConversation,
  deleteMyProfessional,
  professionalExists,
  getMyProfessionalsIds,
};
