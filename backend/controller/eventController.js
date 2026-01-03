// import Event from "../models/Event.js";

// /* CREATE EVENT */
// export const createEvent = async (req, res) => {
//   try {
//     const { title, startTime, endTime } = req.body;

//     if (!title) return res.status(400).json({ message: "Thiếu tiêu đề" });

//     if (new Date(startTime) >= new Date(endTime))
//       return res.status(400).json({ message: "Thời gian không hợp lệ" });

//     const event = await Event.create({
//       ...req.body,
//       owner: req.user._id,
//     });

//     res.status(201).json(event);
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// };

// /* GET EVENTS (user chỉ thấy của mình) */
// export const getMyEvents = async (req, res) => {
//   try {
//     const events = await Event.find({
//       owner: req.user._id,
//       isHidden: false,
//     });

//     res.json(events);
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// };

// /* UPDATE EVENT */
// export const updateEvent = async (req, res) => {
//   try {
//     const event = await Event.findOneAndUpdate(
//       { _id: req.params.id, owner: req.user._id },
//       req.body,
//       { new: true }
//     );

//     if (!event)
//       return res.status(404).json({ message: "Không tìm thấy sự kiện" });

//     res.json(event);
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// };

// /* DELETE EVENT */
// export const deleteEvent = async (req, res) => {
//   try {
//     const event = await Event.findOneAndDelete({
//       _id: req.params.id,
//       owner: req.user._id,
//     });

//     if (!event)
//       return res.status(404).json({ message: "Không tìm thấy sự kiện" });

//     res.json({ message: "Xóa thành công" });
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// };

// /* ADMIN: HIDE EVENT */
// export const hideEvent = async (req, res) => {
//   try {
//     const event = await Event.findByIdAndUpdate(
//       req.params.id,
//       { isHidden: true },
//       { new: true }
//     );

//     res.json(event);
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// };
// export const getAllEvents = async (req, res) => {
//   try {
//     const events = await Event.find().populate("owner", "username email");
//     res.json(events);
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// };
import Event from "../models/Event.js";

/* ================= CREATE EVENT ================= */
// - user: tạo cho chính mình
// - staff: tạo cho user khác
export const createEvent = async (req, res) => {
  try {
    const { title, startTime, endTime, owner } = req.body;

    if (!title || !startTime || !endTime)
      return res.status(400).json({ message: "Thiếu dữ liệu" });

    if (new Date(startTime) >= new Date(endTime))
      return res.status(400).json({ message: "Thời gian không hợp lệ" });

    // user -> owner = chính mình
    // staff -> owner = user được chỉ định
    const eventOwner =
      req.user.role === "staff" && owner ? owner : req.user._id;

    const event = await Event.create({
      ...req.body,
      owner: eventOwner,
      createdBy: req.user._id,
    });

    res.status(201).json(event);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ================= USER: GET MY EVENTS ================= */
// user chỉ thấy event của mình
export const getMyEvents = async (req, res) => {
  try {
    const events = await Event.find({
      owner: req.user._id,
      isHidden: false,
    }).populate("createdBy", "username role");

    res.json(events);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ================= STAFF: GET ALL EVENTS ================= */
// staff chỉ xem, không sửa event user tạo
export const getAllEvents = async (req, res) => {
  try {
    const events = await Event.find()
      .populate("owner", "username email")
      .populate("createdBy", "username role");

    res.json(events);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ================= UPDATE EVENT ================= */
export const updateEvent = async (req, res) => {
  try {
    const event = await Event.findById(req.params.id);
    if (!event)
      return res.status(404).json({ message: "Không tìm thấy sự kiện" });

    // ❌ User không được sửa event do staff tạo
    if (
      req.user.role === "user" &&
      event.createdBy.toString() !== req.user._id.toString()
    ) {
      return res
        .status(403)
        .json({ message: "Bạn không có quyền sửa sự kiện này" });
    }

    // ❌ Staff không được sửa event do user tạo
    if (
      req.user.role === "staff" &&
      event.createdBy.toString() !== req.user._id.toString()
    ) {
      return res
        .status(403)
        .json({ message: "Staff chỉ sửa event do mình tạo" });
    }

    Object.assign(event, req.body);
    await event.save();

    res.json(event);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ================= DELETE EVENT ================= */
// ❌ user KHÔNG được xóa
// ✅ staff CHỈ xóa event do mình tạo
export const deleteEvent = async (req, res) => {
  try {
    const event = await Event.findById(req.params.id);
    if (!event)
      return res.status(404).json({ message: "Không tìm thấy sự kiện" });

    // ❌ User không được xóa event do staff tạo
    if (
      req.user.role === "user" &&
      event.createdBy.toString() !== req.user._id.toString()
    ) {
      return res
        .status(403)
        .json({ message: "Bạn không có quyền xóa sự kiện này" });
    }

    // ❌ Staff không được xóa event do user tạo
    if (
      req.user.role === "staff" &&
      event.createdBy.toString() !== req.user._id.toString()
    ) {
      return res
        .status(403)
        .json({ message: "Staff chỉ xóa event do mình tạo" });
    }

    await event.deleteOne();
    res.json({ message: "Xóa thành công" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ================= ADMIN: HIDE EVENT ================= */
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
