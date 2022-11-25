const insertMessage =
  "INSERT INTO messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_file) VALUES ($1, $2, $3, $4, $5)";

const getConvMessages =
  "SELECT * FROM messages left join file f on messages.mess_file = f.file_uuid where mess_conv_uuid = $1 ORDER BY mess_date ASC";

// mark the other person's messages.
const markReadTheirMessages =
  "UPDATE MESSAGES SET mess_read = true where mess_conv_uuid = $1 and mess_sender <> $2";

const markReadMine =
  "UPDATE MESSAGES SET mess_read = true where mess_conv_uuid = $1 and mess_sender = $2";

module.exports = {
  insertMessage,
  getConvMessages,
  markReadTheirMessages,
  markReadMine,
};
