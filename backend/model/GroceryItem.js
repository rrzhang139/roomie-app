const mongoose = require("mongoose");

const GroceryItemSchema = new mongoose.Schema({
  roommate_group_id: { type: mongoose.Schema.Types.ObjectId, ref: "RoommateGroup", required: true },
  name: { type: String, required: true },
  quantity: { type: Number, required: true },
  needed_by_date: Date,
  added_by: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true }
});

module.exports = mongoose.model("GroceryItem", GroceryItemSchema);
