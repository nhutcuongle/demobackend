// import express from "express";
// import {
//   createReminder,
//   getMyReminders,
//   deleteReminder,
// } from "../controllers/reminderController.js";

// import { authenticate } from "../middlewares/authMiddleware.js";

// const router = express.Router();

// router.use(authenticate);

// router.post("/", createReminder);
// router.get("/", getMyReminders);
// router.delete("/:id", deleteReminder);

// export default router;


import express from "express";
import {
  createReminder,
  getMyReminders,
  deleteReminder,
} from "../controller/reminderController.js";

import { authenticate } from "../middlewares/authMiddleware.js";

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Reminders
 *   description: Quản lý nhắc nhở
 */

router.use(authenticate);

/**
 * @swagger
 * /api/reminders:
 *   post:
 *     summary: Tạo nhắc nhở mới
 *     tags: [Reminders]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - event
 *               - remindAt
 *             properties:
 *               event:
 *                 type: string
 *                 example: 65a123abc456def789
 *               remindAt:
 *                 type: string
 *                 format: date-time
 *                 example: 2026-01-10T08:50:00Z
 *               method:
 *                 type: string
 *                 example: notification
 *     responses:
 *       201:
 *         description: Tạo nhắc nhở thành công
 */
router.post("/", createReminder);

/**
 * @swagger
 * /api/reminders:
 *   get:
 *     summary: Lấy danh sách nhắc nhở của tôi
 *     tags: [Reminders]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Danh sách nhắc nhở
 */
router.get("/", getMyReminders);

/**
 * @swagger
 * /api/reminders/{id}:
 *   delete:
 *     summary: Xóa nhắc nhở
 *     tags: [Reminders]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Xóa thành công
 */
router.delete("/:id", deleteReminder);

export default router;
