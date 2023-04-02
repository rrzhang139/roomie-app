const express = require("express");
const router = express.Router();
const SharedResource = require("../model/SharedResource");
const RoommateGroup = require("../model/RoommateGroup");
const User = require("../model/User");

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
router.post("/", async (req, res, next) => {
  try {
    const newResource = new SharedResource(req.body);
    await newResource.save();
    res.status(201).json(newResource);
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