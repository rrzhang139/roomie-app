const express = require("express");
const router = express.Router();
const GroceryItem = require("../model/GroceryItem");
const RoommateGroup = require("../model/RoommateGroup");
const User = require("../model/User");
const { CustomError } = require("../util/errors");
const auth = require("../middleware/auth");

// GET /grocery-list/group/:id: Get all grocery items for a specific roommate group
router.get("/group/:id", async (req, res, next) => {
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

// GET /grocery-list/user/:id: Get all grocery items for a specific user
router.get("/user/:id", async (req, res, next) => {
  try {
    const { id } = req.params;
    const user = await User.findById(id);
    if (!user) {
      throw new CustomError(404, "User not found");
    }
    const items = await GroceryItem.find({ added_by: id });
    res.status(200).json(items);
  } catch (error) {
    next(error);
  }
});

// POST /grocery-list: Add a new grocery item
router.post("/", async (req, res, next) => {
  try {
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