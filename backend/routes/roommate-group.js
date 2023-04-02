const express = require("express");
const router = express.Router();
const RoommateGroup = require("../model/RoommateGroup");
const User = require("../model/User");
const Bill = require("../model/Bill");
const GroceryItem = require("../model/GroceryItem");
const SharedResource = require("../model/SharedResource");

// GET /roommate-groups: Get all roommate groups
router.get("/", async (req, res) => {
  try {
    const roommateGroups = await RoommateGroup.find();
    res.status(200).json(roommateGroups);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

// GET /roommate-groups/:roommate_group_id: Get all roommates in a group
router.get("/:roommate_group_id", async (req, res) => {
  try {
    const { roommate_group_id } = req.params;
    const roommateGroup = await RoommateGroup.findById(roommate_group_id).populate("roommates");
    res.status(200).json(roommateGroup.roommates);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

// GET /roommate-groups/:roommate_group_id: Get all roommates in a group
router.get("/:roommate_group_id", async (req, res) => {
  try {
    const { roommate_group_id } = req.params;
    const roommate_group = await RoommateGroup.find({ roommate_group_id });
    res.status(200).json(roommate_group);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

// POST /roommate-groups: Add a roommate group
router.post("/", async (req, res) => {
  try {
    const { name, roommates } = req.body;
    const roommateGroup = new RoommateGroup({ name, roommates, tasks: [], bills: [], grocery_items: [] });
    await roommateGroup.save();

    for (const roommateId of roommateGroup.roommates) {
      const user = await User.findById(roommateId);
      const updatedRoommateGroups = user.roommate_group_ids.push(id);
      await User.findByIdAndUpdate(roommateId, { roommate_group_ids: updatedRoommateGroups });
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