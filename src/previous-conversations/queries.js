const getMyPreviousConversations =
  "SELECT y1.user_first_name as fn1, y1.user_last_name as ln1, y2.user_first_name as fn2, y2.user_last_name as ln2, y1.user_uuid as uuid1, y2.user_uuid as uuid2, prco_pdf, prco_date FROM previous_conversation\n" +
  'inner join "user" y1 on prco_user_a = y1.user_uuid ' +
  'inner join "user" y2 on prco_user_b = y2.user_uuid ' +
  "where prco_user_a = $1 or prco_user_b = $1";

const groupedPreviousConversations =
  "SELECT DISTINCT ON (Y1.user_uuid) " +
  "y1.user_first_name as fn1, y1.user_last_name as ln1, y2.user_first_name as fn2, y2.user_last_name as ln2, y1.user_uuid as uuid1, y2.user_uuid as uuid2, prco_pdf, prco_date FROM previous_conversation\n" +
  'inner join "user" y1 on prco_user_a = y1.user_uuid ' +
  'inner join "user" y2 on prco_user_b = y2.user_uuid ' +
  "where prco_user_a = $1 or prco_user_b = $1";

module.exports = {
  getMyPreviousConversations,
  groupedPreviousConversations,
};
