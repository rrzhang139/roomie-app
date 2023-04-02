const mongoose = require("mongoose");

const BillSchema = new mongoose.Schema({
  roommate_group_id: { type: mongoose.Schema.Types.ObjectId, ref: "RoommateGroup", required: true },
  submitter_id: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  // TODO: Add back in
  // grocery_item_id: { type: mongoose.Schema.Types.ObjectId, ref: "GroceryItem", required: true },
  amount: { type: Number, required: true },
  date_submitted: { type: Date, default: Date.now },
  status: { type: String, enum: ["paid", "unpaid"], default: "unpaid" }
});

module.exports = mongoose.model("Bill", BillSchema);
