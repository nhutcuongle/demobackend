import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import cors from "cors";

import swaggerUi from "swagger-ui-express";
import swaggerSpec from "./config/swagger.js";
import authRoutes from "./routes/auth.js";
import eventRoutes from "./routes/event.js";
import reminderRoutes from "./routes/reminder.js";
import userRoutes from "./routes/user.js";
import hideExpiredEvents from "./cron/hideExpiredEvents.js";
import adminRoutes from "./routes/admin.js";
dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/swagger", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

app.use("/api/auth", authRoutes);
app.use("/api/events", eventRoutes);
app.use("/api/reminders", reminderRoutes);
app.use("/api/users", userRoutes);
app.use("/api/admin", adminRoutes);

app.get("/", (req, res) => {
  res.send("API is running...");
});

const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGO_URI;
mongoose.connect(MONGO_URI).then(() => {
  console.log("MongoDB connected");

  hideExpiredEvents(); // 👈 DÒNG BẮT BUỘC – THIẾU HIỆN TẠI

  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
});
