// import User from "../models/User.js";
// import bcrypt from "bcryptjs";
// import jwt from "jsonwebtoken";

// /* Tạo JWT */
// const generateToken = (user) => {
//   return jwt.sign(
//     {
//       id: user._id,
//       role: user.role,
//       username: user.username,
//     },
//     process.env.JWT_SECRET,
//     {
//       expiresIn: process.env.JWT_EXPIRES_IN,
//     }
//   );
// };

// /* REGISTER */
// export const register = async (req, res) => {
//   try {
//     const { username, email, password } = req.body;

//     const exist = await User.findOne({ email });
//     if (exist) return res.status(400).json({ message: "Email đã tồn tại" });

//     const hashedPassword = await bcrypt.hash(password, 10);

//     const user = await User.create({
//       username,
//       email,
//       password: hashedPassword,
//     });

//     const token = generateToken(user);

//     res.status(201).json({
//       message: "Đăng ký thành công",
//     });
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// };

// /* LOGIN */
// export const login = async (req, res) => {
//   try {
//     const { email, password } = req.body;

//     const user = await User.findOne({ email });
//     if (!user) return res.status(404).json({ message: "Không tìm thấy user" });

//     if (user.isDisabled)
//       return res.status(403).json({ message: "Tài khoản bị khóa" });

//     const isMatch = await bcrypt.compare(password, user.password);
//     if (!isMatch) return res.status(401).json({ message: "Sai mật khẩu" });

//     const token = generateToken(user);

//     res.status(200).json({
//       message: "Đăng nhập thành công",
//       token,
//       user: {
//         id: user._id,
//         username: user.username,
//         email: user.email,
//         role: user.role,
//       },
//     });
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// };


import User from "../models/User.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { generateOTP, hashOTP } from "../utils/otp.js";
import { sendOTPEmail } from "../utils/sendEmail.js";

/* JWT */
const generateToken = (user) => {
  return jwt.sign(
    {
      id: user._id,
      role: user.role,
      username: user.username,
    },
    process.env.JWT_SECRET,
    {
      expiresIn: process.env.JWT_EXPIRES_IN,
    }
  );
};

/* REGISTER (GIỮ NGUYÊN) */
export const register = async (req, res) => {
  try {
    const { username, email, password } = req.body;

    const exist = await User.findOne({ email });
    if (exist) return res.status(400).json({ message: "Email đã tồn tại" });

    const hashedPassword = await bcrypt.hash(password, 10);

    await User.create({
      username,
      email,
      password: hashedPassword,
    });

    res.status(201).json({ message: "Đăng ký thành công" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* LOGIN STEP 1: PASSWORD */
export const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ message: "Không tìm thấy user" });

    if (user.isDisabled)
      return res.status(403).json({ message: "Tài khoản bị khóa" });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch)
      return res.status(401).json({ message: "Sai mật khẩu" });

    const otp = generateOTP();

    user.otp = {
      code: hashOTP(otp),
      expiresAt: Date.now() + 5 * 60 * 1000,
    };
    await user.save();

    await sendOTPEmail(user.email, otp);

    res.status(200).json({
      message: "OTP đã gửi qua email",
      otpRequired: true,
      userId: user._id,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* LOGIN STEP 2: VERIFY OTP */
export const verifyOTP = async (req, res) => {
  try {
    const { userId, otp } = req.body;

    const user = await User.findById(userId);
    if (!user || !user.otp)
      return res.status(400).json({ message: "OTP không hợp lệ" });

    if (user.otp.expiresAt < Date.now())
      return res.status(400).json({ message: "OTP đã hết hạn" });

    if (hashOTP(otp) !== user.otp.code)
      return res.status(400).json({ message: "OTP sai" });

    user.otp = undefined;
    await user.save();

    const token = generateToken(user);

    res.status(200).json({
      message: "Đăng nhập thành công",
      token,
      user: {
        id: user._id,
        username: user.username,
        email: user.email,
        role: user.role,
      },
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
