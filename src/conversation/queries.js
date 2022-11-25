const conversationExists =
  "select * from conversation where conv_user_a = $1 and conv_user_b = $2 or conv_user_b = $1 and conv_user_a = $2";

const insertConversation =
  "insert into conversation (conv_uuid, conv_user_a, conv_user_b) VALUES ($1, $2, $3)";

const getMyConversations =
  "SELECT " +
  "conv_uuid, u1.user_uuid as u1_uuid, u1.user_first_name as u1_fn, u1.user_last_name as u1_ln, " +
  "u2.user_uuid as u2_uuid, u2.user_first_name as u2_fn, u2.user_last_name as u2_ln " +
  "FROM conversation " +
  'inner join "user" as u1 on conv_user_a = u1.user_uuid ' +
  'inner join "user" as u2 on conv_user_b = u2.user_uuid ' +
  "where conv_user_a = $1 " +
  "or conv_user_b = $1";

const getConversationRecord = "select * from conversation where conv_uuid = $1";

module.exports = {
  conversationExists,
  insertConversation,
  getMyConversations,
  getConversationRecord,
};
