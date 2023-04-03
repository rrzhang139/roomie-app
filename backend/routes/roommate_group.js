const express = require("express");
const router = express.Router();
const RoommateGroup = require("../model/RoommateGroup");
const User = require("../model/User");
const Bill = require("../model/Bill");
const GroceryItem = require("../model/GroceryItem");
const SharedResource = require("../model/SharedResource");
const { CustomError } = require("../util/errors");
const auth = require("../middleware/auth");

// GET /roommate-groups/:roommate_group_id: Get roommate group by ID
// router.get("/", async (req, res) => {
//   try {
//     const roommateGroups = await RoommateGroup.find({_id: });
//     res.status(200).json(roommateGroups);
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ message: "Internal server error" });
//   }
// });

// GET /roommate-groups/roommates/:roommate_group_id: Get all roommates in a group
// AUTH HERE
router.get("/roommates/:roommate_group_id", auth, async (req, res) => {
  try {
    const user_id = req.user.id;
    const { roommate_group_id } = req.params;
    const roommateGroup = await RoommateGroup.findById(roommate_group_id).populate("roommates");
    res.status(200).json(roommateGroup.roommates);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

// GET /roommate-groups/: Get all roommate groups for a user
// AUTH HERE
router.get("/", auth, async (req, res, next) => {
  try {
    const user_id = req.user.id;
    const user = await User.findById(user_id);

    if (!user) {
      throw new CustomError(404, "User not found");
    }

    const roommateGroups = await RoommateGroup.find({ _id: { $in: user.roommate_group_ids } })
      .populate("roommates")
      .populate("grocery_items")
      .populate("shared_resources")
      .populate("bills");

    res.status(200).json(roommateGroups);
  } catch (error) {
    next(error);
  }
});

// POST /roommate-groups: Add a roommate group
// AUTH HERE
router.post("/", auth, async (req, res) => {
  try {
    const user_id = req.user.id;
    const { name, roommate_emails } = req.body;

    if (!Array.isArray(roommate_emails)) {
      return res.status(400).json({ message: "roommate_emails must be an array" });
    }

    const roommates = [user_id];
    for (const email of roommate_emails) {
      const user = await User.findOne({ email });
      if (!user) {
        return res.status(404).json({ message: `User with email ${email} not found` });
      }
      roommates.push(user._id);
    }

    const roommateGroup = new RoommateGroup({ name, owner_id: user_id, roommates, tasks: [], bills: [], grocery_items: [] });
    await roommateGroup.save();
    const id = roommateGroup._id;

    for (const roommateId of roommateGroup.roommates) {
      await User.updateOne(
        { _id: roommateId },
        { $push: { roommate_group_ids: id } }
      );
    }

    res.status(201).json(roommateGroup);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

// POST /roommate-groups/add-roommate/:roommate_group_id: Add a roommate to a roommate group
// AUTH HERE
router.post("/add-roommate/:roommate_group_id", auth, async (req, res) => {
  try {
    const user_id = req.user.id;
    const { roommate_group_id } = req.params;
    const { email } = req.body;

    // Find the user with the provided email
    const userToAdd = await User.findOne({ email });
    if (!userToAdd) {
      return res.status(404).json({ message: "User not found" });
    }

    // Find the roommate group and ensure the requesting user is the owner
    const roommateGroup = await RoommateGroup.findById(roommate_group_id);
    if (!roommateGroup) {
      return res.status(404).json({ message: "Roommate group not found" });
    }

    if (roommateGroup.owner_id.toString() !== user_id) {
      return res.status(403).json({ message: "Only the owner of the roommate group can add users" });
    }

    // Add the user to the roommate group and save
    roommateGroup.roommates.push(userToAdd._id);
    await roommateGroup.save();

    res.status(200).json({ message: "User added to the roommate group", roommateGroup });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

// ON HOLD FOR FUTURE FEATURE
// PUT /roommate-groups/:roommate_group_id: Update RoommateGroup By ID
// AUTH HERE
router.put("/:roommate_group_id", async (req, res) => {
  try {
    const { id } = req.params;
    const { name, roommates, tasks, bills, grocery_items } = req.body;
    const task = await RoommateGroup.findByIdAndUpdate(id, { name, roommates, tasks, bills, grocery_items }, { new: true });

    if (!task) {
      return res.status(404).json({ message: "Task not found" });
    }

    res.status(200).json(task);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

// DELETE /roommate-groups/:id: Remove a roommate group by ID
// AUTH HERE
router.delete("/:id", auth, async (req, res) => {
  try {
    const user_id = req.user.id;
    const { id } = req.params;
    const roommateGroup = await RoommateGroup.findById(id);

    if (!roommateGroup) {
      return res.status(404).json({ message: "Roommate group not found" });
    }

    if (!roommateGroup.roommates.includes(user_id)) {
      return res.status(403).json({ message: "You do not have permission to delete this group" });
    }

    for (const roommateId of roommateGroup.roommates) {
      const user = await User.findById(roommateId);
      const updatedRoommateGroups = user.roommate_group_ids.filter(roommateGroupId => !roommateGroupId.equals(id));
      await User.findByIdAndUpdate(roommateId, { roommate_group_ids: updatedRoommateGroups });
    }

    await Bill.deleteMany({ roommate_group_id: id });
    await GroceryItem.deleteMany({ roommate_group_id: id });
    await SharedResource.deleteMany({ roommate_group_id: id });

    await RoommateGroup.findByIdAndDelete(id);
    res.status(200).json({ message: "Roommate group successfully deleted" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

module.exports = router;