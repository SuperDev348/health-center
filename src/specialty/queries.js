const get =
  "SELECT * FROM specialty inner join category on spec_cate_id = cate_id";

const insert =
  "INSERT INTO specialty(spec_cate_id, spec_specialty) VALUES ($1, $2) RETURNING *";

const del = "DELETE from specialty where spec_id = $1";

const put =
  "UPDATE specialty set spec_cate_id = $1, spec_specialty = $2 where spec_id = $3";

const specialties = get + " where spec_cate_id = $1";

module.exports = {
  get,
  insert,
  del,
  put,
  specialties,
};
