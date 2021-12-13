// Link controller file to express route

const bcrypt = require("bcryptjs");
const userServices = require("../services/users.services");

/**
 * 1. To secure the password, we are using the bcryptjs, It stores the hashed password in the database.
 * 2. In the SignIn API, we are checking whether the assigned and retrieved passwords are the same or not using the bcrypt.compare() method.
 * 3. In the SignIn API, we set the JWT token expiration time. Token will be expired within the defined duration.
 */

exports.sign_up = (req, res, next) => {
    /** fetch password from request body which contains req.body.user.password
     *  const {username, password} = req.body; fecthes both from body
     */
    const { password } = req.body;

    const salt = bcrypt.genSaltSync(10);

    // apply bcrypt encryption when user first signs up at all times | hash passwowrd using salt
    req.body.password = bcrypt.hashSync(password, salt);

    userServices.sign_up(req.body, (error, results) => {
        // user did not register successfully
        if (error) {
            return next(error);
        }
        // user registered successfully
        return res.status(200).send({
            message: "Success",
            data: results, // data generated from mongoose db
        });
    });
};

exports.login = (req, res, next) => {
    const { username, password } = req.body;

    userServices.login({ username, password }, (error, results) => {
        if (error) {
            return next(error);
        }
        // successfully log in
        return res.status(200).send({
            message: "Success",
            data: results, // data from user service api
        });
    });
};

// displayed only when login/signup successful
exports.userProfile = (req, res, next) => {
    return res.status(401).json({ message: "Authorized User!!" });
};