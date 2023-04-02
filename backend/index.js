const express = require("express");
const bodyParser = require("body-parser");
const user = require("./routes/user");
const task = require("./routes/task");
const InitiateMongoServer = require("./config/db");
const cron = require("node-cron");
// const rotateExpiredTasks = require("./rotateExpiredTasks");

// Initiate Mongo Server
InitiateMongoServer();

const app = express();

// PORT
const PORT = process.env.PORT || 4000;

// Middleware
app.use(bodyParser.json());

app.get("/", (req, res) => {
  res.json({ message: "API Working" });
});

/**
 * Router Middleware
 * Router - /user/*
 * Method - *
 */
app.use("/user", user);
app.use("/tasks", task);

// Schedule the task rotation to run every day at 00:00 (midnight)
// cron.schedule("0 0 * * *", rotateExpiredTasks);

app.listen(PORT, (req, res) => {
  console.log(`Server Started at PORT ${PORT}`);
});
