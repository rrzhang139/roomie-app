const express = require("express");
const router = express.Router();
const GroceryItem = require("../model/GroceryItem");
const RoommateGroup = require("../model/RoommateGroup");
const User = require("../model/User");
const { CustomError } = require("../util/errors");
const auth = require("../middleware/auth");

// GET /grocery-list/group/:id: Get all grocery items for a specific roommate group
router.get("/group/:id", auth, async (req, res, next) => {
  try {
    const { id } = req.params;
    const group = await RoommateGroup.findById(id).populate("grocery_items");
    if (!group) {
      throw new CustomError(404, "Roommate group not found");
    }
    res.status(200).json(group.grocery_items);
  } catch (error) {
    next(error);
  }
});

// GET /grocery-list/user: Get all grocery items for a specific user
router.get("/user", auth, async (req, res, next) => {
  try {
    const user_id = req.user.id;
    const user = await User.findById(user_id);
    if (!user) {
      throw new CustomError(404, "User not found");
    }
    const items = await GroceryItem.find({ added_by: user_id });
    res.status(200).json(items);
  } catch (error) {
    next(error);
  }
});

// POST /grocery-list: Add a new grocery item
router.post("/", auth, async (req, res, next) => {
  try {

    // Find the roommate group and ensure the requesting user is a part of the group
    const roommateGroup = await RoommateGroup.findById(roommate_group_id);
    if (!roommateGroup) {
      return res.status(404).json({ message: "Roommate group not found" });
    }
    if (!group.roommates.includes(user_id)) {
      return res.status(403).json({ message: "You do not have permission to add this resource" });
    }
    const newItem = new GroceryItem(req.body);
    await newItem.save();
    res.status(201).json(newItem);
  } catch (error) {
    next(error);
  }
});

// PUT /grocery-list/:id: Update grocery item details by ID
router.put("/:id", async (req, res, next) => {
  try {
    const { id } = req.params;
    const updatedItem = await GroceryItem.findByIdAndUpdate(id, req.body, { new: true });
    if (!updatedItem) {
      throw new CustomError(404, "Grocery item not found");
    }
    res.status(200).json(updatedItem);
  } catch (error) {
    next(error);
  }
});

// DELETE /grocery-list/:id: Delete a grocery item by ID
router.delete("/:id", async (req, res, next) => {
  try {
    const { id } = req.params;
    const deletedItem = await GroceryItem.findByIdAndDelete(id);
    if (!deletedItem) {
      throw new CustomError(404, "Grocery item not found");
    }
    res.status(200).json({ message: "Grocery item deleted successfully" });
  } catch (error) {
    next(error);
  }
});

module.exports = router;