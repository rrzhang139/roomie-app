const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  first_name: { type: String, required: true },
  last_name: { type: String, required: true },
  roommate_group_ids: [{ type: mongoose.Schema.Types.ObjectId, ref: 'RoommateGroup' }]
});

const User = mongoose.model('User', userSchema);

module.exports = User; 