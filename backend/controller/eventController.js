  import Event from "../models/Event.js";

  /* ================= CREATE EVENT ================= */
  // - user: tạo cho chính mình
  // - staff: tạo cho user khác
  export const createEvent = async (req, res) => {
    try {
      const { title, description, startTime, endTime, owner } = req.body;

      if (!title || !startTime || !endTime) {
        return res.status(400).json({ message: "Thiếu dữ liệu" });
      }

      if (new Date(startTime) >= new Date(endTime)) {
        return res.status(400).json({ message: "Thời gian không hợp lệ" });
      }

      // staff BẮT BUỘC phải chọn user
      if (req.user.role === "staff" && !owner) {
        return res
          .status(400)
          .json({ message: "Staff phải chọn user để tạo sự kiện" });
      }

      const eventOwner = req.user.role === "staff" ? owner : req.user._id;

      const event = await Event.create({
        title,
        description,
        startTime,
        endTime,
        owner: eventOwner,
        createdBy: req.user._id,
      });

      return res.status(201).json(event);
    } catch (err) {
      console.error("CREATE EVENT ERROR:", err);
      return res.status(500).json({ error: err.message });
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
      if (!event) {
        return res.status(404).json({ message: "Không tìm thấy sự kiện" });
      }

      const { title, description, startTime, endTime } = req.body;

      // ✅ ép kiểu Date
      const newStartTime = startTime ? new Date(startTime) : event.startTime;

      const newEndTime = endTime ? new Date(endTime) : event.endTime;

      // ✅ validate thời gian
      if (newStartTime >= newEndTime) {
        return res.status(400).json({ message: "Thời gian không hợp lệ" });
      }

      // ✅ update từng field
      if (title !== undefined) event.title = title;
      if (description !== undefined) event.description = description;
      if (startTime !== undefined) event.startTime = newStartTime;
      if (endTime !== undefined) event.endTime = newEndTime;

      await event.save();

      res.json(event);
    } catch (err) {
      console.error("UPDATE EVENT ERROR:", err);
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
