// Creation and authorization of JWT using custom middleware helper method
/** Used to check auth token sent from client in request header
 * Create and send a token to the client
 * authenticateToken implemented here
 */

const jwt = require("jsonwebtoken");

function authenticateToken(req, res, next) {
    // auth header | auth variable
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    // fetch token from request and check
    if (token == null) return res.sendStatus(401);

    // use any secret key
    jwt.verify(token, "process.env.TOKEN_SECRET", (err, user) => {
        console.log(err);
        // check if error and return forbidden 
        if (err) return res.sendStatus(403);
        req.user = user;
        next();
    });
}

// function called from login api | user obtains token after successful login within the response
function generateAccessToken(username) {
    return jwt.sign({ data: username }, "process.env.TOKEN_SECRET", {
        // expiration time
        expiresIn: "1h",
    });
}

const authJwt = {
    authenticateToken: authenticateToken
};

// export methods
module.exports = {
    authenticateToken,
    generateAccessToken,
    authJwt,
};