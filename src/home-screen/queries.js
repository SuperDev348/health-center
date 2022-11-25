const insert =
  "INSERT INTO home_screen (hosc_uuid, hosc_file, hosc_type) VALUES($1, $2, $3)";
const del = "DELETE FROM home_screen WHERE hosc_uuid = $1";
const getCurrent =
  "SELECT * FROM home_screen where LOWER(hosc_type) = $1 LIMIT 1";

module.exports = {
  insert,
  del,
  getCurrent,
};
