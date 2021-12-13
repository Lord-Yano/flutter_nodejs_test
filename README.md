# Run Applications

- # Express Node JS server
- cd into expressserver directory 
- run "npm install" to install dependencies
- run npm start to start server

- # Flutter application
- cd into weighttracker_flutter
- run "dart pub get" to install dependencies
- run "flutter run" to start flutter application

- # Server url : localhost

# Project Structure

1. Back-end  : Server created using MEN (Mongo DB, Express and Node JS)
2. Front-end : UI Application using Flutter (Web/Mobile)

# 1. Back-end  : Server

## Packages Used
- bcryptjs : Encrypt password
- express : Provide server-side logic for web and mobile applications
- express-unless : Conditionally skip a middleware when a condition is met
- jsonwebtoken : To share security information between two parties — a client and a server
- mongoose : Provide schema validation and translate between objects in code and the representation of those objects in MongoDB
- mongoose-unique-validator : Error handling
- nodemon : Automatically restart the node application when file changes in the directory are detected

## Config
- Database config files for db url and secret keys

## Controllers
- Used for the business layer 

## Middleware
- auth.js will be used with JWT for authentication
- errors.js will be used to handle errors

## Routes
- Used for routing

## Services
- Used for handling database making use of the business logic

# 2. Front-end : Flutter UI

## Packages Used