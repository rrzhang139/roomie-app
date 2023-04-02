const mongoose = require("mongoose");

const SharedResourceSchema = new mongoose.Schema({
  roommate_group_id: { type: mongoose.Schema.Types.ObjectId, ref: "RoommateGroup", required: true },
  name: { type: String, required: true },
  owner_id: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  resource_duration: Number,
  status: { type: String, enum: ["available", "in-use"], default: "available" }
});

module.exports = mongoose.model("SharedResource", SharedResourceSchema);
