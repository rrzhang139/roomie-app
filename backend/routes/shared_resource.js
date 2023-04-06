const express = require("express");
const router = express.Router();
const SharedResource = require("../model/SharedResource");
const RoommateGroup = require("../model/RoommateGroup");
const User = require("../model/User");
const auth = require("../middleware/auth");

// GET /shared-resources/group/:id: Get all shared resources for a specific roommate group
router.get("/group/:id", async (req, res, next) => {
  try {
    const { id } = req.params;
    const group = await RoommateGroup.findById(id).populate("shared_resources");
    if (!group) {
      throw new CustomError(404, "Roommate group not found");
    }
    res.status(200).json(group.shared_resources);
  } catch (error) {
    next(error);
  }
});

// GET /shared-resources/user/:id: Get all shared resources for a specific user
router.get("/user/:id", async (req, res, next) => {
  try {
    const { id } = req.params;
    const user = await User.findById(id);
    if (!user) {
      throw new CustomError(404, "User not found");
    }
    const resources = await SharedResource.find({ owner_id: id });
    res.status(200).json(resources);
  } catch (error) {
    next(error);
  }
});

// POST /shared-resources: Add a new shared resource
router.post("/", auth, async (req, res, next) => {
  try {
    const user_id = req.user.id;
    const { roommate_group_id, name, owner_id } = req.body;

    // Find the roommate group and ensure the requesting user is a part of the group
    const roommateGroup = await RoommateGroup.findById(roommate_group_id);
    if (!roommateGroup) {
      return res.status(404).json({ message: "Roommate group not found" });
    }
    if (!group.roommates.includes(user_id)) {
      return res.status(403).json({ message: "You do not have permission to add this resource" });
    }

    const newResource = new SharedResource({ roommate_group_id, name, owner_id, resource_duration: 0, status: "available" });
    await newResource.save();
    res.status(201).json(newResource);
  } catch (error) {
    next(error);
  }
});

// PUT /shared-resources/:id: Occupy shared resource by ID
router.put("/occupy/:id", auth, async (req, res, next) => {
  try {
    const user_id = req.user.id;
    const { id } = req.params;
    const { resource_duration } = req.body;

    const group = await RoommateGroup.findOne({ shared_resources: { $in: [id] } });

    if (!group) {
      return res.status(404).json({ message: "Group not found" });
    }

    if (!group.roommates.includes(user_id)) {
      return res.status(403).json({ message: "You do not have permission to occupy this resource" });
    }

    const updatedResource = await SharedResource.findByIdAndUpdate(id, { resource_duration, status: "in-use" }, { new: true });
    if (!updatedResource) {
      throw new CustomError(404, "Shared resource not found");
    }
    res.status(200).json(updatedResource);
  } catch (error) {
    next(error);
  }
});

// PUT /shared-resources/:id: Update shared resource details by ID
router.put("/:id", async (req, res, next) => {
  try {
    const { id } = req.params;
    const updatedResource = await SharedResource.findByIdAndUpdate(id, req.body, { new: true });
    if (!updatedResource) {
      throw new CustomError(404, "Shared resource not found");
    }
    res.status(200).json(updatedResource);
  } catch (error) {
    next(error);
  }
});

// DELETE /shared-resources/:id: Delete a shared resource by ID
router.delete("/:id", async (req, res, next) => {
  try {
    const { id } = req.params;
    const deletedResource = await SharedResource.findByIdAndDelete(id);
    if (!deletedResource) {
      throw new CustomError(404, "Shared resource not found");
    }
    res.status(200).json({ message: "Shared resource deleted successfully" });
  } catch (error) {
    next(error);
  }
});

module.exports = router;