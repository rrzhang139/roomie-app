const express = require("express");
const router = express.Router();
const RoommateGroup = require("../model/RoommateGroup");
const User = require("../model/User");
const Bill = require("../model/Bill");
const GroceryItem = require("../model/GroceryItem");
const SharedResource = require("../model/SharedResource");
const { CustomError } = require("../util/errors");

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
router.get("/roommates/:roommate_group_id", async (req, res) => {
  try {
    const { roommate_group_id } = req.params;
    const roommateGroup = await RoommateGroup.findById(roommate_group_id).populate("roommates");
    res.status(200).json(roommateGroup.roommates);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

// GET /roommate-groups/roommate-groups/:user_id: Get all roommate groups for a user
router.get("/roommate-groups/:userId", async (req, res, next) => {
  try {
    const { userId } = req.params;
    const user = await User.findById(userId);

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
router.post("/", async (req, res) => {
  try {
    const { name, roommates } = req.body;
    const roommateGroup = new RoommateGroup({ name, roommates, tasks: [], bills: [], grocery_items: [] });
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

// ON HOLD FOR FUTURE FEATURE
// PUT /roommate-groups/:roommate_group_id: Update RoommateGroup By ID
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
router.delete("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const roommateGroup = await RoommateGroup.findById(id);

    if (!roommateGroup) {
      return res.status(404).json({ message: "Roommate group not found" });
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