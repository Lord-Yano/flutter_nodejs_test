/** Errors middleware to manage the response pushed to the client side.
 *  Error middleware needs to be called after route middleware */

function errorHandler(err, req, res, next) {
    // checking object type "==="
    if (typeof err === "string") {
        // custom application error
        return res.status(400).json({ message: err });
    }

    // check validation error from mongoose db
    if (err.name === "ValidationError") {
        // mongoose validation error
        return res.status(400).json({ message: err.message });
    }

    if (err.name === "UnauthorizedError") {
        // jwt authentication error
        return res.status(401).json({ message: "Token not valid" });
    }

    // default to 500 server error
    return res.status(500).json({ message: err.message });
}

// export module
module.exports = {
    errorHandler,
};