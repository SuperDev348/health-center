const { Router } = require("express");
const router = Router();

const {
  getUsers,
  getUserById,
  insertUser,
  signIn,
  me,
  verify,
  forgotPassword,
  verifyPwdCode,
  resetPassword,
  updateUserDeleted,
  updateUserRole,
  getModerators,
  getModeratorsFromUser,
  updateBlocked,
  changePassword,
  putUser,
  searchUser,
  getAdmin,
  temporalUser,
  unarchive,
  updatePicture,
  refresh,
  logout,
  practiceAddress,
} = require("./controller");
const validation = require("../../middleware/validation");
const authorized = require("../../middleware/authorized");
const adminOnly = require("../../middleware/admin-only");

router.get("/", [authorized], getUsers);
router.get("/admin", [], getAdmin);
router.get("/search", [], searchUser);
router.get("/me", authorized, me);
router.get("/moderators", [authorized], getModerators);
router.get("/moderators/:id", [authorized], getModeratorsFromUser);
router.get("/practice-address/:uuid", [], practiceAddress);
router.get("/:id", [], getUserById);

router.post(
  "/",
  [
    validation.email,
    validation.first_name,
    validation.last_name,
    validation.password,
    validation.confirm_password,
    validation.country_code,
    validation.phone_no,
  ],
  insertUser
);
router.post("/sign-in", [validation.email, validation.password], signIn);

router.post("/verify", [authorized, validation.code], verify);
router.post(
  "/verify-password-code",
  [validation.email, validation.code],
  verifyPwdCode
);
router.post("/tmp", validation.first_name, temporalUser);
router.patch(
  "/password",
  [
    validation.password,
    validation.confirm_password,
    validation.email,
    validation.code,
  ],
  resetPassword
);

router.post(
  "/change-password",
  [validation.old_password, validation.password, validation.confirm_password],
  changePassword
);

router.post("/send-verification-code", [validation.email], verify);
router.post("/forgot-password", [validation.email], forgotPassword);

// is admin, is moderator or is super admin
router.delete("/:id", [authorized], updateUserDeleted);
router.put("/role/:id", [authorized, validation.key], updateUserRole);
router.put("/blocked/:id", [authorized], updateBlocked);

router.put(
  "/",
  [authorized, validation.first_name, validation.last_name],
  putUser
);

router.post("/unarchive/:uuid", [authorized, adminOnly], unarchive);

router.post("/picture", [authorized], updatePicture);

router.post("/refresh", refresh);

router.post("/logout", [authorized], logout);

module.exports = router;
