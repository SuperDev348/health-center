const insertFile =
  "INSERT INTO file (file_uuid, file_title, file_name) VALUES ($1, $2, $3) RETURNING *";

module.exports = {
  insertFile,
};
