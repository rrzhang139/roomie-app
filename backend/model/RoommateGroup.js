const mongoose = require("mongoose");

const RoommateGroupSchema = new mongoose.Schema({
  name: { type: String, required: true },
  owner_id: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  roommates: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
  tasks: [{ type: mongoose.Schema.Types.ObjectId, ref: "Task" }],
  bills: [{ type: mongoose.Schema.Types.ObjectId, ref: "Bill" }],
  grocery_items: [{ type: mongoose.Schema.Types.ObjectId, ref: "GroceryItem" }]
});

module.exports = mongoose.model("RoommateGroup", RoommateGroupSchema);
