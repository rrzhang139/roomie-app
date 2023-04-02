const express = require("express");
const router = express.Router();
const Bill = require("../model/Bill");
const User = require("../model/User");
const RoommateGroup = require("../model/RoommateGroup");
const { CustomError } = require("../util/errors");

// GET /bills/user/:userId: Get all bills for a specific user
router.get("/user/:userId", async (req, res, next) => {
  try {
    const { userId } = req.params;
    const bills = await Bill.find({ submitter_id: userId });
    res.status(200).json(bills);
  } catch (error) {
    next(error);
  }
});

// GET /bills/roommate-group/:groupId: Get all bills for a specific roommate-group
router.get("/roommate-group/:groupId", async (req, res, next) => {
  try {
    const { groupId } = req.params;
    const bills = await Bill.find({ roommate_group_id: groupId });
    res.status(200).json(bills);
  } catch (error) {
    next(error);
  }
});

// POST /bills/: Create a new bill
router.post("/unpaid", async (req, res, next) => {
  try {
    const { roommate_group_id, submitter_id, grocery_item_id, amount, date_submitted } = req.body;
    const newBill = new Bill({ roommate_group_id, submitter_id, grocery_item_id, amount, date_submitted });
    const savedBill = await newBill.save();
    res.status(201).json(savedBill);
  } catch (error) {
    next(error);
  }
});

// PUT /bills/:id/pay: Update bill status to "paid" by ID
router.put("/:id/pay", async (req, res, next) => {
  try {
    const { id } = req.params;
    const updatedBill = await Bill.findByIdAndUpdate(id, { status: "paid" }, { new: true });
    if (!updatedBill) {
      throw new CustomError(404, "Bill not found");
    }
    res.status(200).json(updatedBill);
  } catch (error) {
    next(error);
  }
});

// PUT /bills/:id: Update bill details by ID
router.put("/:id", async (req, res, next) => {
  try {
    const { id } = req.params;
    const updatedBill = await Bill.findByIdAndUpdate(id, req.body, { new: true });
    if (!updatedBill) {
      throw new CustomError(404, "Bill not found");
    }
    res.status(200).json(updatedBill);
  } catch (error) {
    next(error);
  }
});

// DELETE /bills/:id: Delete a bill by ID
router.delete("/:id", async (req, res, next) => {
  try {
    const { id } = req.params;
    const deletedBill = await Bill.findByIdAndDelete(id);
    if (!deletedBill) {
      throw new CustomError(404, "Bill not found");
    }
    res.status(200).json({ message: "Bill deleted successfully" });
  } catch (error) {
    next(error);
  }
});

module.exports = router;