const Weight = require("../models/weight.model");

module.exports = {
    saveWeight: (req, res) => {
        req.body.userID = req.user._id;

        Weight.create(req.body)
            .then((weight) => {
                res.status(200).json({
                    success: true,
                    weight,
                });
            })
            .catch((err) => {
                res.status(500).json({
                    success: false,
                    message: err.message,
                });
            });
    },
    updateWeight: (req, res) => {
        let body = req.body;
        let id = req.body.id;
        delete body.id;
        Weight.findByIdAndUpdate(id, body, { new: true })
            .then((weight) => {
                res.status(200).json({
                    success: true,
                    weight,
                });
            })
            .catch((err) => {
                res.status(500).json({
                    success: false,
                    message: err.message,
                });
            });
    },

    deleteWeight: (req, res) => {
        Weight.findByIdAndRemove(req.params.id)
            .then(() => {
                res.status(200).json({
                    success: true,
                    message: "succeed",
                });
            })
            .catch((err) => {
                res.status(500).json({
                    success: false,
                    message: err.message,
                });
            });
    },

    getWeightsByUser: (req, res) => {
        let userID = req.user._id;
        console.log(userID);
        Weight.find({ userID })
            .then((weights) => {
                res.status(200).json({
                    success: true,
                    weights,
                });
            })
            .catch((err) => {
                res.status(500).json({
                    success: false,
                    message: err.message,
                });
            });
    },
};