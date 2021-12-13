// API routing

const usersController = require("../controllers/users.controller");

// used for routing purposes
const express = require("express");
const router = express.Router();

router.post("/sign_up", usersController.sign_up);
router.post("/login", usersController.login);
router.get("/user-Profile", usersController.userProfile);

module.exports = router;