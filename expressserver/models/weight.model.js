const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const WeightSchema = mongoose.Schema(
    {
        weight: {
            type: Number,
            trim: true,
            required: true,
        },
        unit: {
            type: String,
            default: "kg",
            require: true,
        },
        userID: {
            type: String,
            required: true,
        },
    },
    { timestamps: true }
);

module.exports = mongoose.model("Weight", WeightSchema);