const insert = "INSERT into category (cate_category) VALUES($1) RETURNING *";
const del = "DELETE FROM category where cate_id = $1";
const update = "UPDATE category SET cate_category = $1 where cate_id = $2;";
const get = "SELECT * FROM category";

module.exports = {
  insert,
  del,
  update,
  get,
};
