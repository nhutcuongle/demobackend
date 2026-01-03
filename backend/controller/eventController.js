import Event from "../models/Event.js";

/* CREATE EVENT */
export const createEvent = async (req, res) => {
  try {
    const { title, startTime, endTime } = req.body;

    if (!title) return res.status(400).json({ message: "Thiếu tiêu đề" });

    if (new Date(startTime) >= new Date(endTime))
      return res.status(400).json({ message: "Thời gian không hợp lệ" });

    const event = await Event.create({
      ...req.body,
      owner: req.user._id,
    });

    res.status(201).json(event);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* GET EVENTS (user chỉ thấy của mình) */
export const getMyEvents = async (req, res) => {
  try {
    const events = await Event.find({
      owner: req.user._id,
      isHidden: false,
    });

    res.json(events);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* UPDATE EVENT */
export const updateEvent = async (req, res) => {
  try {
    const event = await Event.findOneAndUpdate(
      { _id: req.params.id, owner: req.user._id },
      req.body,
      { new: true }
    );

    if (!event)
      return res.status(404).json({ message: "Không tìm thấy sự kiện" });

    res.json(event);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* DELETE EVENT */
export const deleteEvent = async (req, res) => {
  try {
    const event = await Event.findOneAndDelete({
      _id: req.params.id,
      owner: req.user._id,
    });

    if (!event)
      return res.status(404).json({ message: "Không tìm thấy sự kiện" });

    res.json({ message: "Xóa thành công" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ADMIN: HIDE EVENT */
export const hideEvent = async (req, res) => {
  try {
    const event = await Event.findByIdAndUpdate(
      req.params.id,
      { isHidden: true },
      { new: true }
    );

    res.json(event);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
export const getAllEvents = async (req, res) => {
  try {
    const events = await Event.find().populate("owner", "username email");
    res.json(events);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
