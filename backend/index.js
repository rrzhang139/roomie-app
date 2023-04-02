const express = require("express");
const bodyParser = require("body-parser");
const user = require("./routes/user");
const task = require("./routes/task");
const roommate_group = require("./routes/roommate_group");
const bill = require("./routes/bill");
const grocery_list = require("./routes/grocery_list");
const shared_resource = require("./routes/shared_resource");
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
app.use("/roommate-groups", roommate_group);
app.use("/bills", bill);
app.use("/grocery-list", grocery_list);
app.use("/shared-resources", shared_resource);

// Schedule the task rotation to run every day at 00:00 (midnight)
// cron.schedule("0 0 * * *", rotateExpiredTasks);

app.use((error, req, res, next) => {
  const statusCode = error.statusCode || 500;
  const message = error.message || "Internal server error";
  res.status(statusCode).json({ message });
});

app.listen(PORT, (req, res) => {
  console.log(`Server Started at PORT ${PORT}`);
});
