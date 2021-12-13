const express = require("express");
const router = express.Router();
const weightController = require("../controllers/weight.controller");
const { authJwt } = require("../middlewares/auth");

router.post(
    "/save_weight",
    [authJwt.authenticateToken],
    weightController.saveWeight
);

router.post(
    "/update_weight",
    [authJwt.authenticateToken],
    weightController.updateWeight
);

router.get("/get_weight_history", weightController.getWeightsByUser);
router.get("/delete_weight/:id", weightController.deleteWeight);

module.exports = router;