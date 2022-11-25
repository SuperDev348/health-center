const insert = "INSERT INTO main_text (mate_uuid, mate_text, mate_text_b) VALUES($1, $2, $3)";
const del = "DELETE from main_text where mate_uuid = $1";
const getOne = "SELECT * FROM main_text limit 1";

module.exports = {
  insert,
  del,
  getOne,
};
