const getPP = "SELECT * FROM privacy_policy limit 1";
const deletePrivacyPolicy = "DELETE from privacy_policy";
const insertPrivacyPolicy = "INSERT INTO privacy_policy (prpo_text) VALUES($1)";

const getTC = "SELECT * FROM terms_conditions limit 1";
const deleteTC = "DELETE FROM terms_conditions";
const insertTC = "INSERT INTO terms_conditions (teco_text) VALUES($1)";

module.exports = {
  getPP,
  deletePrivacyPolicy,
  insertPrivacyPolicy,
  getTC,
  deleteTC,
  insertTC,
};
