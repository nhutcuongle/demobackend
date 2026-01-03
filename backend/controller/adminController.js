import User from "../models/User.js";
import bcrypt from "bcryptjs";

/* ADMIN: GET ALL STAFF */
export const getAllStaff = async (req, res) => {
  try {
    const staff = await User.find({ role: "staff" }).select("-password");
    res.json(staff);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ADMIN: CREATE STAFF */
export const createStaff = async (req, res) => {
  try {
    const { username, email, password } = req.body;

    const exists = await User.findOne({ email });
    if (exists)
      return res.status(400).json({ message: "Email đã tồn tại" });

    const hashedPassword = await bcrypt.hash(password, 10);

    const staff = await User.create({
      username,
      email,
      password: hashedPassword,
      role: "staff",
    });

    res.status(201).json({
      message: "Tạo tài khoản staff thành công",
      staff: {
        id: staff._id,
        username: staff.username,
        email: staff.email,
        role: staff.role,
      },
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ADMIN: UPDATE STAFF */
export const updateStaff = async (req, res) => {
  try {
    const { username, email, password, isDisabled } = req.body;

    const staff = await User.findOne({ _id: req.params.id, role: "staff" });
    if (!staff)
      return res.status(404).json({ message: "Không tìm thấy staff" });

    if (username) staff.username = username;
    if (email) staff.email = email;
    if (typeof isDisabled === "boolean") staff.isDisabled = isDisabled;

    if (password) {
      staff.password = await bcrypt.hash(password, 10);
    }

    await staff.save();

    res.json({ message: "Cập nhật staff thành công" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ADMIN: DELETE STAFF */
export const deleteStaff = async (req, res) => {
  try {
    const staff = await User.findOneAndDelete({
      _id: req.params.id,
      role: "staff",
    });

    if (!staff)
      return res.status(404).json({ message: "Không tìm thấy staff" });

    res.json({ message: "Xóa staff thành công" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
