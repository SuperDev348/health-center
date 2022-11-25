const insert = "INSERT INTO my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ($1, $2, $3)"
const get = 'SELECT * FROM my_doctor inner join "user" on mydo_user_uuid = user_uuid where mydo_owner = $1'

const get5 = get + ' limit 5'

const del = 'DELETE FROM my_doctor where mydo_uuid = $1'
const doIOwnIt = 'SELECT * FROM my_doctor where mydo_owner = $1 and mydo_user_uuid = $2'


module.exports = {
  insert,
  get,
  get5,
  del,
  doIOwnIt
}