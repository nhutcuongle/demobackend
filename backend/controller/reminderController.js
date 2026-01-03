import Reminder from "../models/Reminder.js";

/* CREATE REMINDER */
export const createReminder = async (req, res) => {
  try {
    const reminder = await Reminder.create({
      ...req.body,
      owner: req.user._id,
    });

    res.status(201).json(reminder);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* GET MY REMINDERS */
export const getMyReminders = async (req, res) => {
  try {
    const reminders = await Reminder.find({ owner: req.user._id })
      .populate("event");

    res.json(reminders);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* DELETE REMINDER */
export const deleteReminder = async (req, res) => {
  try {
    const reminder = await Reminder.findOneAndDelete({
      _id: req.params.id,
      owner: req.user._id,
    });

    if (!reminder)
      return res.status(404).json({ message: "Không tìm thấy reminder" });

    res.json({ message: "Xóa thành công" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
