import User from "../models/User.js";


export const getAllUsers = async (req, res) => {
  try {
    const users = await User.find({ role: "user" }).select("-password");
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
/* ADMIN: DISABLE USER */
export const disableUser = async (req, res) => {
  try {
    const user = await User.findByIdAndUpdate(
      req.params.id,
      { isDisabled: true },
      { new: true }
    );

    if (!user)
      return res.status(404).json({ message: "Không tìm thấy user" });

    res.json({ message: "Khóa user thành công" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ADMIN: ENABLE USER (OPTIONAL) */
export const enableUser = async (req, res) => {
  try {
    const user = await User.findByIdAndUpdate(
      req.params.id,
      { isDisabled: false },
      { new: true }
    );

    res.json({ message: "Mở khóa user thành công" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
/* STAFF: GET USERS ĐỂ GÁN LỊCH */
export const getAssignableUsers = async (req, res) => {
  try {
    const users = await User.find({
      role: "user",
      isDisabled: false,
    }).select("_id username email");

    res.json(users);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ADMIN: DELETE USER (CHỈ ROLE = USER) */
export const deleteUser = async (req, res) => {
  try {
    const user = await User.findOneAndDelete({
      _id: req.params.id,
      role: "user",
    });

    if (!user)
      return res.status(404).json({ message: "Không tìm thấy user" });

    res.json({ message: "Xóa user thành công" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
