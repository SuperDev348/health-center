const insert =
  "INSERT INTO page (page_uuid, page_title, page_slug, page_keywords, page_content) VALUES ($1, $2, $3, $4, $5)";

const del = "delete from page where page_uuid = $1";

const put =
  "UPDATE page set page_title = $1, page_slug = $2, page_keywords = $3, page_content = $4, page_updated_at = $5 where page_uuid = $6";

const get = "SELECT * FROM page";
const getUUID = "SELECT * FROM page WHERE page_uuid = $1";

module.exports = {
  insert,
  del,
  put,
  get,
  getUUID,
};
