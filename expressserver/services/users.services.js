// consume user model to create login/signup methods

const User = require("../models/user.model");
const bcrypt = require("bcryptjs");
const auth = require("../middlewares/auth.js"); // used to pass token in api

async function login({ username, password }, callback) {
    const user = await User.findOne({ username });

    // found a user
    if (user != null) {
        // compare password created using salt function
        if (bcrypt.compareSync(password, user.password)) {
            // get token if matched from auth middleware
            const token = auth.generateAccessToken(username);
            // call toJSON method applied during model instantiation
            return callback(null, { ...user.toJSON(), token });
        } else {
            return callback({
                message: "Invalid Username/Password!",
            });
        }
    } else {
        return callback({
            message: "Invalid Username/Password!",
        });
    }
}

async function sign_up(params, callback) {
    // if usename is not passed in the body of the api
    if (params.username === undefined) {
        console.log(params.username);
        return callback(
            {
                message: "Username Required",
            },
            ""
        );
    }

    // else, create user
    const user = new User(params);
    user
        .save()
        .then((response) => {
            return callback(null, response);
        })
        .catch((error) => {
            return callback(error);
        });
}

// export functions
module.exports = {
    login,
    sign_up,
};