const Task = require("../model/Task");
const RoommateGroup = require("../model/RoommateGroup");
const express = require("express");
const router = express.Router();
const { CustomError } = require("../util/errors");

// // GET /tasks: Get all tasks
// router.get("/", async (req, res) => {
//   try {
//     const tasks = await Task.find();
//     res.status(200).json(tasks);
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ message: "Internal server error" });
//   }
// });

// GET /tasks/user/:user_id: Get all tasks for a particular user
router.get("/user/:user_id", async (req, res) => {
  try {
    const { user_id } = req.params;
    const tasks = await Task.find({ user_id });
    if (!tasks) {
      throw new CustomError(404, "Task not found");
    }
    res.status(200).json(tasks);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

// GET /tasks/user/:roommate_group_id: Get all tasks for a particular RoommateGroup
router.get("/user/:roommate_group_id", async (req, res) => {
  try {
    const { roommate_group_id } = req.params;
    const tasks = await Task.find({ roommate_group_id });
    if (!tasks) {
      throw new CustomError(404, "Task not found");
    }
    res.status(200).json(tasks);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

// POST /tasks: Create a new task
router.post("/", async (req, res) => {
  try {
    const { user_id, name, description, due_date, status, roommate_group_id } = req.body;
    const due_date_object = new Date(due_date);
    const task = new Task({ user_id, name, description, due_date_object, status, roommate_group_id });

    // TODO: INSERT GOOGLE CAL API
    await task.save();
    res.status(201).json(task);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

// PUT /tasks/:id: Update a task by ID
router.put("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { user_id, name, description, due_date, status, roommate_group_id } = req.body;
    const task = await Task.findByIdAndUpdate(id, { user_id, name, description, due_date, status, roommate_group_id }, { new: true });

    if (!task) {
      return res.status(404).json({ message: "Task not found" });
    }

    res.status(200).json(task);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

// DELETE /tasks/:id: Delete a task by ID
router.delete("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const task = await Task.findByIdAndDelete(id);

    if (!task) {
      return res.status(404).json({ message: "Task not found" });
    }

    res.status(200).json({ message: "Task deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

module.exports = router;

async function rotateExpiredTasks() {
  try {
    // Find all tasks with expired due dates
    const expiredTasks = await Task.find({ due_date: { $lt: new Date() } });

    // Rotate each expired task
    for (const task of expiredTasks) {
      const roommateGroup = await RoommateGroup.findOne({ tasks: task._id }).populate("roommates");

      if (!roommateGroup) {
        console.error(`Roommate group not found for task with ID ${task._id}`);
        continue;
      }

      const currentUserIndex = roommateGroup.roommates.findIndex(
        (user) => user.id === task.user_id.toString()
      );

      const nextUserIndex = (currentUserIndex + 1) % roommateGroup.roommates.length;
      const nextUser = roommateGroup.roommates[nextUserIndex];

      task.user_id = nextUser.id;
      task.due_date = new Date(task.due_date.getTime() + 7 * 24 * 60 * 60 * 1000); // Add 7 days to the current due_date

      await task.save();
    }

    console.log("Expired tasks rotated successfully");
  } catch (error) {
    console.error("Error rotating expired tasks:", error);
  }
}




// /**
//  * @method - POST
//  * @param - /rotateTask
//  * @description - Rotate a Task to Next User
//  */

// router.post("/rotateTask", async (req, res) => {
//   try {
//     const { groupId, taskId } = req.body;

//     const roommateGroup = await RoommateGroup.findById(groupId).populate("roommates");

//     if (!roommateGroup) {
//       return res.status(404).json({ message: "Roommate group not found" });
//     }

//     const task = await Task.findById(taskId);

//     if (!task) {
//       return res.status(404).json({ message: "Task not found" });
//     }

//     // Get the index of the current user who has the task assigned
//     const currentUserIndex = roommateGroup.roommates.findIndex(
//       (user) => user.id === task.user_id.toString()
//     );

//     // Assign the task to the next user in the group
//     const nextUserIndex = (currentUserIndex + 1) % roommateGroup.roommates.length;
//     const nextUser = roommateGroup.roommates[nextUserIndex];

//     // Update the task's user_id and due_date
//     task.user_id = nextUser.id;
//     task.due_date = new Date(task.due_date.getTime() + 7 * 24 * 60 * 60 * 1000); // Add 7 days to the current due_date

//     await task.save();

//     res.status(200).json({ message: "Task rotated successfully", task });
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ message: "Internal server error" });
//   }
// });

// module.exports = router;