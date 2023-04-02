const mongoose = require("mongoose");

const TaskSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  name: { type: String, required: true },
  description: String,
  due_date: Date,
  status: { type: String, enum: ["completed", "in-progress"], default: "in-progress" },
  roommate_group_id: { type: mongoose.Schema.Types.ObjectId, ref: "RoommateGroup", required: true },
});

module.exports = mongoose.model("Task", TaskSchema);