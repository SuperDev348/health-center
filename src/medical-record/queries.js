const insert =
  "INSERT INTO medical_record (mere_uuid, mere_owner, mere_name, mere_allergies, mere_current_meds, mere_medical_history, mere_social_history, mere_family_history, mere_bp, mere_pulse, mere_resp_rate, mere_temp, mere_height, mere_weight, mere_chief_complaint, mere_hpi, mere_subject, mere_objective, mere_assessment, mere_plan, mere_sign, mere_addendum, mere_date, mere_is_public) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24) RETURNING *";

const put =
  "UPDATE medical_record SET mere_owner = $1, mere_name = $2, mere_allergies = $3, mere_current_meds = $4, mere_medical_history = $5, mere_social_history = $6, mere_family_history = $7, mere_bp = $8, mere_pulse = $9, mere_resp_rate = $10, mere_temp = $11, mere_height = $12, mere_weight = $13, mere_chief_complaint = $14, mere_hpi = $15, mere_subject = $16, mere_objective = $17, mere_assessment = $18, mere_plan = $19, mere_sign = $20, mere_addendum = $21, mere_updated = current_timestamp, mere_date = $22, mere_is_draft = false WHERE mere_uuid = $23";

const insertRecord =
  "insert into medical_record_user (mrus_uuid, mrus_mere_uuid, mrus_user_uuid) values ($1, $2, $3)";

const insertDraft =
  "INSERT INTO medical_record (mere_uuid, mere_owner, mere_is_draft, mere_is_encounter) VALUES ($1, $2, true, $3) RETURNING *";

const get =
  'SELECT * from medical_record LEFT JOIN medical_record_user on mrus_mere_uuid = mere_uuid left join "user" on mrus_user_uuid = user_uuid  where mere_uuid = $1';

const getForPdf =
  "SELECT " +
  "profe_practice_name as practice_name, " +
  "concat_ws(', ', addr_line1, addr_city, addr_state, addr_zip) as address, " +
  "concat_ws(' ', concat_ws(', ', owner.user_last_name, owner.user_first_name), profe_credentials) as professional, " +
  "concat_ws(' ', patient.user_first_name, patient.user_last_name) as patient, " +
  "patient.user_date_of_birth as patient_dob, " +
  "medical_record.* " +
  "from medical_record " +
  "LEFT JOIN medical_record_user on mrus_mere_uuid = mere_uuid " +
  'left join "user" as owner on mere_owner = owner.user_uuid ' +
  "left join address on addr_owner = owner.user_uuid " +
  "left join professional on profe_user_uuid = owner.user_uuid " +
  'left join "user" as patient on mrus_user_uuid = patient.user_uuid where mere_uuid = $1';

const del = "DELETE from medical_record where mere_uuid = $1";

const deleteRecord = "DELETE from medical_record_user where mrus_uuid = $1";

const getMyRecords =
  'SELECT * FROM medical_record LEFT JOIN medical_record_user on mrus_mere_uuid = mere_uuid left join "user" on mrus_user_uuid = user_uuid where mrus_user_uuid IS NOT NULL and mere_owner = $1';

const searchMyRecords =
  "SELECT * FROM medical_record LEFT JOIN medical_record_user on mrus_mere_uuid = mere_uuid " +
  'left join "user" on mrus_user_uuid = user_uuid ' +
  "where (concat_ws(' ', LOWER(user_first_name), LOWER(user_last_name)) like $1 or concat_ws('',user_mrn, '') like $1) and (mrus_user_uuid IS NOT NULL) and mere_owner = $2";
// Concat user_mrn to make it a string. Otherwise, we would get an error.

const searchMyTemplates =
  "SELECT * FROM medical_record LEFT JOIN medical_record_user on mrus_mere_uuid = mere_uuid " +
  'left join "user" on mrus_user_uuid = user_uuid ' +
  "where (LOWER(mere_name) like $1) and (mrus_user_uuid IS NULL) and (mere_owner = $2 or mere_is_public)";

const searchAllTemplates =
  "SELECT * FROM medical_record LEFT JOIN medical_record_user on mrus_mere_uuid = mere_uuid " +
  'left join "user" on mrus_user_uuid = user_uuid ' +
  "where (LOWER(mere_name) like $1) and (mrus_user_uuid IS NULL)";

const getMyTemplates =
  'SELECT * FROM medical_record LEFT JOIN medical_record_user on mrus_mere_uuid = mere_uuid left join "user" on mrus_user_uuid = user_uuid where (mere_owner = $1 or mere_is_public) and mrus_user_uuid IS NULL';

const getAllRecords =
  'SELECT * FROM medical_record LEFT JOIN medical_record_user on mrus_mere_uuid = mere_uuid left join "user" on mrus_user_uuid = user_uuid where mrus_user_uuid IS NOT NULL';

const getAllTemplates =
  "SELECT mere_uuid, mere_name, u2.user_uuid as owner_uuid, u2.user_first_name as owner_name, u2.user_last_name as owner_last_name, mere_date FROM medical_record LEFT JOIN medical_record_user on mrus_mere_uuid = mere_uuid " +
  'left join "user" on mrus_user_uuid = user_uuid ' +
  'left join "user" as u2 on u2.user_uuid = mere_owner ' +
  "where mrus_user_uuid IS NULL";

const getMyPatients =
  'SELECT concat_ws(\' \', user_first_name, user_last_name) as full_name, mere_uuid, user_uuid FROM medical_record inner join medical_record_user mru on medical_record.mere_uuid = mru.mrus_mere_uuid left join "user" on mru.mrus_user_uuid = "user".user_uuid where mere_owner = $1';

const patchUser =
  "UPDATE medical_record set patient = $1 where mere_uuid = $2 and mere_owner = $3";

const hasUserSet =
  "SELECT * from medical_record left join medical_record_user on mere_uuid = mrus_mere_uuid where mere_uuid = $1";

const setUserMR =
  "UPDATE medical_record_user set mrus_user_uuid = $1 where mrus_uuid = $2";

const patchDate =
  "UPDATE medical_record set mere_date = $1 where mere_uuid = $2 and mere_owner = $3";

const patchAllergies =
  "UPDATE medical_record set mere_allergies = $1 where mere_uuid = $2 and mere_owner = $3";
const patchCurrentMeds =
  "UPDATE medical_record set mere_current_meds = $1 where mere_uuid = $2 and mere_owner = $3";
const patchMedicalHistory =
  "UPDATE medical_record set mere_medical_history = $1 where mere_uuid = $2 and mere_owner = $3";
const patchSocialHistory =
  "UPDATE medical_record set mere_social_history = $1 where mere_uuid = $2 and mere_owner = $3";
const patchFamilyHistory =
  "UPDATE medical_record set mere_family_history = $1 where mere_uuid = $2 and mere_owner = $3";
const patchBP =
  "UPDATE medical_record set mere_bp = $1 where mere_uuid = $2 and mere_owner = $3";
const patchPulse =
  "UPDATE medical_record set mere_pulse = $1 where mere_uuid = $2 and mere_owner = $3";
const patchRespRate =
  "UPDATE medical_record set mere_resp_rate = $1 where mere_uuid = $2 and mere_owner = $3";
const patchTemp =
  "UPDATE medical_record set mere_temp = $1 where mere_uuid = $2 and mere_owner = $3";
const patchHeight =
  "UPDATE medical_record set mere_height = $1 where mere_uuid = $2 and mere_owner = $3";
const patchWeight =
  "UPDATE medical_record set mere_weight = $1 where mere_uuid = $2 and mere_owner = $3";
const patchChiefComplaint =
  "UPDATE medical_record set mere_chief_complaint = $1 where mere_uuid = $2 and mere_owner = $3";
const patchHPI =
  "UPDATE medical_record set mere_hpi = $1 where mere_uuid = $2 and mere_owner = $3";
const patchSubject =
  "UPDATE medical_record set mere_subject = $1 where mere_uuid = $2 and mere_owner = $3";
const patchObjective =
  "UPDATE medical_record set mere_objective = $1 where mere_uuid = $2 and mere_owner = $3";
const patchAssessment =
  "UPDATE medical_record set mere_assessment = $1 where mere_uuid = $2 and mere_owner = $3";
const patchPlan =
  "UPDATE medical_record set mere_plan = $1 where mere_uuid = $2 and mere_owner = $3";
const patchSign =
  "UPDATE medical_record set mere_sign = $1 where mere_uuid = $2 and mere_owner = $3";
const patchAddendum =
  "UPDATE medical_record set mere_addendum = $1 where mere_uuid = $2 and mere_owner = $3";

const patchTemplateName =
  "UPDATE medical_record set mere_name = $1 where mere_uuid = $2 and mere_owner = $3";

module.exports = {
  hasUserSet,
  insert,
  del,
  put,
  insertRecord,
  deleteRecord,
  getMyRecords,
  getMyTemplates,
  get,
  getAllRecords,
  getAllTemplates,
  getForPdf,
  searchMyRecords,
  searchMyTemplates,
  searchAllTemplates,
  getMyPatients,
  insertDraft,
  setUserMR,
  patchDate,
  patchAllergies,
  patchCurrentMeds,
  patchMedicalHistory,
  patchSocialHistory,
  patchFamilyHistory,
  patchBP,
  patchPulse,
  patchRespRate,
  patchTemp,
  patchHeight,
  patchWeight,
  patchChiefComplaint,
  patchHPI,
  patchSubject,
  patchObjective,
  patchAssessment,
  patchPlan,
  patchSign,
  patchAddendum,
  patchTemplateName,
};
