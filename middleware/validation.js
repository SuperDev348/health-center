const { body } = require("express-validator");

module.exports = {
  email: body("email")
    .isLength({ min: 1 })
    .withMessage("The email is required")
    .isEmail()
    .withMessage("Enter a valid email"),
  first_name: body("first_name")
    .isLength({ min: 3 })
    .withMessage("The first name must have at least 3 characters")
    .isLength({ max: 30 })
    .withMessage("The first name must have a maximum of 30 characters"),
  code: body("code")
    .isLength({ min: 9 })
    .withMessage("The code must have at least 9 characters")
    .isLength({ max: 9 })
    .withMessage("The code must have a maximum of 9 characters"),
  last_name: body("last_name")
    .isLength({ min: 3 })
    .withMessage("The last name must have at least 3 characters")
    .isLength({ max: 30 })
    .withMessage("The last name must have a maximum of 30 characters"),
  country_code: body("country_code")
    .isLength({ min: 1 })
    .withMessage("The country code must have a minimum of 1 character")
    .isLength({ max: 4 })
    .withMessage("The country code name must have a maximum of 3 characters"),
  phone_no: body("phone_no")
    .isLength({ min: 10, max: 10 })
    .withMessage("The phone number must contain exactly 10 digits."),
  dob: body("dob")
    .trim()
    .isLength({ min: 1 })
    .withMessage("The date of birth is required")
    .isLength({ max: 10 })
    .isDate()
    .withMessage("Enter a valid date of birth"),
  old_password: body("old_password")
    .trim()
    .isLength({ min: 6 })
    .withMessage("Your password must contain at least 6 characters")
    .isLength({ max: 30 })
    .withMessage("Your password must contain a maximum of 30 characters"),
  password: body("password")
    .trim()
    .isLength({ min: 6 })
    .withMessage("Your password must contain at least 6 characters")
    .isLength({ max: 30 })
    .withMessage("Your password must contain a maximum of 30 characters"),
  confirm_password: body("confirm_password").custom((value, { req }) => {
    if (value !== req.body.password) {
      throw new Error("Password confirmation does not match the password");
    }
    return true;
  }),
  key: body("key")
    .trim()
    .isLength({ min: 1 })
    .withMessage("The key is required"),
  category: body("category")
    .isLength({ min: 2 })
    .withMessage("The category must have at least 2 characters")
    .isLength({ max: 60 })
    .withMessage("The category must have a maximum of 60 characters"),
};
