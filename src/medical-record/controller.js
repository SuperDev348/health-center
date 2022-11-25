const {
  decodedToken,
  sendError,
  isAdmin,
  createIfNotExists,
  deleteIfExists,
} = require("../../utils");
const pool = require("../../db");
const queries = require("./queries");
const { v4: uuidv4 } = require("uuid");
const pdf = require("html-pdf");
const path = require("path");
const { query } = require("express-validator");

function getData(req, owner, doNotGenerateUUID) {
  doNotGenerateUUID = doNotGenerateUUID || false;
  const {
    template_name,
    allergies,
    current_meds,
    medical_history,
    social_history,
    family_history,
    bp,
    pulse,
    resp_rate,
    temp,
    height,
    weight,
    chief_complaint,
    hip,
    subject,
    objective,
    assessment,
    plan,
    sign,
    addendum,
    date,
    patchTemplateName,
  } = req.body;

  let t = [
    owner || "",
    template_name || "",
    allergies || "",
    current_meds || "",
    medical_history || "",
    social_history || "",
    family_history || "",
    bp || "",
    pulse || "",
    resp_rate || "",
    temp || "",
    parseFloat(height || "0"),
    parseFloat(weight || "0"),
    chief_complaint || "",
    hip || "",
    subject || "",
    objective || "",
    assessment || "",
    plan || "",
    sign || "",
    addendum || "",
    date,
  ];

  if (!doNotGenerateUUID) {
    t.unshift(uuidv4());
  }
  return t;
}

const insertTemplate = (req, res) => {
  const owner = decodedToken(req).uuid;
  const data = getData(req, owner);
  const is_admin = isAdmin(req);
  if (is_admin) {
    data.push("true");
  } else {
    data.push("false");
  }
  pool.query(queries.insert, data, function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json();
    }
  });
};

const insertRecord = (req, res) => {
  const owner = decodedToken(req).uuid;
  const data = getData(req, owner);
  const patient = req.body.patient;

  data.push("false"); // is_public

  pool.query(queries.insert, data, function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      pool.query(
        queries.insertRecord,
        [uuidv4(), results.rows[0].mere_uuid, patient],
        function (err, r2) {
          if (err) {
            sendError(res, { msg: err });
          } else {
            res.json();
          }
        }
      );
    }
  });
};

const getMyRecords = (req, res) => {
  const owner = decodedToken(req).uuid;
  const isRecord = req.query.type && req.query.type === "record";
  const search = req.query.search || "";

  if (search && search.length && search.length > 0) {
    let qry = isRecord ? queries.searchMyRecords : queries.searchMyTemplates;
    if (isAdmin(req) && !isRecord) {
      qry = queries.searchAllTemplates;
      pool.query(qry, ["%" + search + "%"], function (err, results) {
        if (err) {
          return sendError(res, { msg: err });
        }
        res.json(results.rows);
      });
    } else {
      const s = "%" + search + "%";

      pool.query(qry, [s, owner], function (err, results) {
        if (err) {
          return sendError(res, { msg: err });
        }
        res.json(results.rows);
      });
    }
  } else {
    let q = isRecord ? queries.getMyRecords : queries.getMyTemplates;
    if (isAdmin(req)) {
      q = isRecord ? queries.getMyRecords : queries.getAllTemplates;
    }
    if (isAdmin(req) && !isRecord) {
      pool.query(q, function (err, results) {
        if (err) {
          sendError(res, { msg: err });
        } else {
          res.json(results.rows);
        }
      });
    } else {
      pool.query(q, [owner], function (err, results) {
        if (err) {
          sendError(res, { msg: err });
        } else {
          res.json(results.rows);
        }
      });
    }
  }
};

const del = (req, res) => {
  const uuid = req.params.uuid;
  pool.query(queries.del, [uuid], function (err) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json();
    }
  });
};

const get = (req, res) => {
  const uuid = req.params.uuid;
  pool.query(queries.get, [uuid], function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json(results.rows[0]);
    }
  });
};

const put = (req, res) => {
  const uuid = decodedToken(req).uuid;
  const data = getData(req, uuid, true);
  data.push(req.params.uuid);
  pool.query(queries.put, data, function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json();
    }
  });
};

const generatePdf = (req, res) => {
  const uuid = req.params.uuid;
  pool.query(queries.getForPdf, [uuid], function (err, results) {
    if (err) {
      return sendError(res, { msg: err });
    }
    if (results.rows && results.rows.length > 0) {
      const r = results.rows[0];

      const base = "generated/record/";
      createIfNotExists(base);

      const fName = r.mere_uuid + ".pdf";
      const pdfFile = path.join(base, fName);

      deleteIfExists(pdfFile);

      const d = new Date(r.mere_date);
      r.date = d.toLocaleDateString("en-US");

      const d2 = new Date(r.mere_updated);
      r.updated = d2.toLocaleDateString("en-US");

      const d3 = new Date(r.patient_dob);
      r.patient_dob = d3.toLocaleDateString("en-US");

      const h = parseFloat(r.mere_height);
      const w = parseFloat(r.mere_weight);

      if (h > 0 && w > 0) {
        r.bmi = ((w / h / h) * 703).toFixed(2);
      } else {
        r.bmi = 0;
      }

      r.url = process.env.BASE_URL + "/r/" + r.mere_uuid + ".pdf";

      res.render("record", r, async function (err, str) {
        pdf
          .create(str, {
            size: "Letter",
            border: { top: "0in", left: "0.2in", right: "0.2in" },
            footer: {
              height: "26mm",
              contents: {
                default:
                  '<div id="pageFooter" style="font-size: 12px;"><b>' +
                  'Page {{page}} of {{pages}}</div><div style="margin-top: 0.9rem">' +
                  '<p class="text-muted text-center" style="font-size: 8px !important; color: #ccc">' +
                  r.url +
                  "</p></div",
              },
            },
          })
          .toFile(pdfFile, (err) => {
            if (err) return sendError(res, { msg: err });
            res.json({ file: fName });
          });
      });
    } else {
      sendError(res, { msg: err });
    }
  });
};

const getMyPatients = (req, res) => {
  const uuid = decodedToken(req).uuid;
  pool.query(queries.getMyPatients, [uuid], function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      res.json(results.rows);
    }
  });
};

const draft = (req, res) => {
  let { type } = req.body;
  if (type && typeof type === "string") {
    type = type.toLowerCase();
    const types = ["new", "template"];

    if (types.includes(type)) {
      const isEncounter = type === "new";
      const owner = decodedToken(req).uuid;
      pool.query(
        queries.insertDraft,
        [uuidv4(), owner, isEncounter],
        function (err, results) {
          if (err) return sendError(res, { msg: err });
          res.json(results.rows[0]);
        }
      );
    } else {
      sendError(res, { msg: "Wrong type value" });
    }
  } else {
    sendError(res, { msg: "Missing type parameter or wrong data type" });
  }
};

const getPatchData = (req) => {
  const record = req.params.uuid;
  const owner = decodedToken(req).uuid;
  const { value } = req.body;
  return { record, owner, value };
};

const patchUser = (req, res) => {
  const { record, value } = getPatchData(req);

  pool.query(queries.hasUserSet, [record], function (err, results) {
    if (err) {
      sendError(res, { msg: err });
    } else {
      const c = results.rows;
      if (c.length > 0 && c[0].mrus_uuid) {
        pool.query(queries.setUserMR, [value, c[0].mrus_uuid], function (err) {
          if (err) return sendError(res, { msg: err });
          res.json();
        });
      } else {
        pool.query(
          queries.insertRecord,
          [uuidv4(), record, value],
          function (err) {
            if (err) return sendError(res, { msg: err });
            res.json();
          }
        );
      }
      res.json(c);
    }
  });
  // pool.query(queries.patchUser, [], function (err, results) {});
};

const patchGeneral = (req, res, query) => {
  const { record, value, owner } = getPatchData(req);
  pool.query(query, [value, record, owner], function (err, results) {
    if (err) return sendError(res, { msg: err });
    res.json();
  });
};

const patchDate = (req, res) => {
  patchGeneral(req, res, queries.patchDate);
};

const patchAllergies = (req, res) => {
  patchGeneral(req, res, queries.patchAllergies);
};

const patchCurrentMeds = (req, res) => {
  patchGeneral(req, res, queries.patchCurrentMeds);
};

const patchMedicalHistory = (req, res) => {
  patchGeneral(req, res, queries.patchMedicalHistory);
};

const patchSocialHistory = (req, res) => {
  patchGeneral(req, res, queries.patchSocialHistory);
};

const patchFamilyHistory = (req, res) => {
  patchGeneral(req, res, queries.patchFamilyHistory);
};

const patchBP = (req, res) => {
  patchGeneral(req, res, queries.patchBP);
};

const patchPulse = (req, res) => {
  patchGeneral(req, res, queries.patchPulse);
};

const patchRespRate = (req, res) => {
  patchGeneral(req, res, queries.patchRespRate);
};

const patchTemp = (req, res) => {
  patchGeneral(req, res, queries.patchTemp);
};
const patchHeight = (req, res) => {
  patchGeneral(req, res, queries.patchHeight);
};
const patchWeight = (req, res) => {
  patchGeneral(req, res, queries.patchWeight);
};
const patchChiefComplaint = (req, res) => {
  patchGeneral(req, res, queries.patchChiefComplaint);
};

const patchHPI = (req, res) => {
  patchGeneral(req, res, queries.patchHPI);
};

const patchSubject = (req, res) => {
  patchGeneral(req, res, queries.patchSubject);
};

const patchObjective = (req, res) => {
  patchGeneral(req, res, queries.patchObjective);
};
const patchAssessment = (req, res) => {
  patchGeneral(req, res, queries.patchAssessment);
};

const patchPlan = (req, res) => {
  patchGeneral(req, res, queries.patchPlan);
};

const patchSign = (req, res) => {
  patchGeneral(req, res, queries.patchSign);
};

const patchAddendum = (req, res) => {
  patchGeneral(req, res, queries.patchAddendum);
};

const patchTemplateName = (req, res) => {
  patchGeneral(req, res, queries.patchTemplateName);
};

module.exports = {
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
};
