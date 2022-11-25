const Router = require("express").Router;
const router = Router();
const authorized = require("../../middleware/authorized");
const {
  insertTemplate,
  insertRecord,
  getMyRecords,
  del,
  get,
  put,
  generatePdf,
  getMyPatients,
  draft,
  patchUser,
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
} = require("./controller");

router.get("/patients", [authorized], getMyPatients);
router.get("/:uuid", [authorized], get);
router.get("/", [authorized], getMyRecords);
router.post("/", [authorized], insertTemplate);
router.get("/pdf/:uuid", [authorized], generatePdf);
router.put("/:uuid", [authorized], put);
router.post("/record", [authorized], insertRecord);
router.delete("/:uuid", [authorized], del);
router.post("/draft", [authorized], draft);

router.patch("/user/:uuid", [authorized], patchUser);
router.patch("/date/:uuid", [authorized], patchDate);
router.patch("/allergies/:uuid", [authorized], patchAllergies);
router.patch("/current-meds/:uuid", [authorized], patchCurrentMeds);
router.patch("/medical-history/:uuid", [authorized], patchMedicalHistory);
router.patch("/social-history/:uuid", [authorized], patchSocialHistory);
router.patch("/family-history/:uuid", [authorized], patchFamilyHistory);
router.patch("/bp/:uuid", [authorized], patchBP);
router.patch("/pulse/:uuid", [authorized], patchPulse);
router.patch("/resp-rate/:uuid", [authorized], patchRespRate);
router.patch("/temp/:uuid", [authorized], patchTemp);
router.patch("/height/:uuid", [authorized], patchHeight);
router.patch("/weight/:uuid", [authorized], patchWeight);
router.patch("/chief-complaint/:uuid", [authorized], patchChiefComplaint);
router.patch("/hip/:uuid", [authorized], patchHPI);
router.patch("/subject/:uuid", [authorized], patchSubject);
router.patch("/objective/:uuid", [authorized], patchObjective);
router.patch("/assessment/:uuid", [authorized], patchAssessment);
router.patch("/plan/:uuid", [authorized], patchPlan);
router.patch("/sign/:uuid", [authorized], patchSign);
router.patch("/addendum/:uuid", [authorized], patchAddendum);
router.patch("/template-name/:uuid", [authorized], patchTemplateName);

module.exports = router;
