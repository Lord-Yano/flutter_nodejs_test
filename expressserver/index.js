// import modules
const express = require("express");
const app = express();
const mongoose = require("mongoose");
const dbConfig = require("./config/db.config");

// import middleware
const auth = require("./middlewares/auth.js");
const errors = require("./middlewares/errors.js");
const unless = require("express-unless");

// connect to mongodb

/**
 * With useNewUrlParser: The underlying MongoDB driver has deprecated their current connection string parser. 
 * Because this is a major change, they added the useNewUrlParser flag to allow users to fall back to the old parser if they find a bug in the new parser. 
 * You should set useNewUrlParser: true unless that prevents you from connecting.
 * 
 * With useUnifiedTopology, the MongoDB driver sends a heartbeat every heartbeatFrequencyMS to check on the status of the connection. 
 * A heartbeat is subject to serverSelectionTimeoutMS , so the MongoDB driver will retry failed heartbeats for up to 30 seconds by default.
 */

// set as global to use in different positions within the project
mongoose.Promise = global.Promise;
mongoose
    .connect(dbConfig.db, {
        useNewUrlParser: true,
        useUnifiedTopology: true,
    })
    .then(
        () => {
            console.log("Database connected");
        },
        (error) => {
            console.log("Database can't be connected: " + error);
        }
    );

// middleware for authenticating token submitted with requests
/**
 * Conditionally skip a middleware when a condition is met.
 * Unless checks for the condition of wether or not the user has a token and redirects to a page accordingly
 */
auth.authenticateToken.unless = unless;
app.use(
    auth.authenticateToken.unless({ // pages that do not require token
        path: [
            { url: "/users/login", methods: ["POST"] },
            { url: "/users/sign_up", methods: ["POST"] },
        ],
    })
);

// incoming request is processed as a json object | method called as middleware in app
app.use(express.json());

// initialize routes
app.use("/users", require("./routes/users.routes")); // user route
//app.use("/users", require("./routes/auth.routes")); // auth route
app.use("/users", require("./routes/weight.routes")); // weight route


// middleware for error responses
app.use(errors.errorHandler);

const PORT = process.env.PORT || 4000;
// listen for requests | start server
app.listen(PORT, function () {
    console.log(`Server started on port ${PORT}`);
});