import nodemailer from "nodemailer";

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

export const sendOTPEmail = async (to, otp) => {
  await transporter.sendMail({
    from: `"Security" <${process.env.EMAIL_USER}>`,
    to,
    subject: "Mã xác thực OTP",
    html: `
      <h2>Mã OTP đăng nhập</h2>
      <h1>${otp}</h1>
      <p>Mã có hiệu lực trong <b>5 phút</b></p>
    `,
  });
};
