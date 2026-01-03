// export default router;
import express from "express";
import {
  createEvent,
  getMyEvents,
  getAllEvents,
  updateEvent,
  deleteEvent,
  hideEvent,
} from "../controller/eventController.js";

import {
  authenticate,
  isAdmin,
  isStaff,
} from "../middlewares/authMiddleware.js";

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Events
 *   description: Quản lý lịch / sự kiện
 */

router.use(authenticate);

/**
 * @swagger
 * /api/events:
 *   post:
 *     summary: Tạo sự kiện (User tạo cho mình, Staff tạo cho user khác)
 *     tags: [Events]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - title
 *               - startTime
 *               - endTime
 *             properties:
 *               title:
 *                 type: string
 *                 example: Họp dự án
 *               description:
 *                 type: string
 *                 example: Họp triển khai sprint
 *               startTime:
 *                 type: string
 *                 format: date-time
 *                 example: 2026-01-10T09:00:00Z
 *               endTime:
 *                 type: string
 *                 format: date-time
 *                 example: 2026-01-10T10:00:00Z
 *               owner:
 *                 type: string
 *                 description: ID user được gán lịch (chỉ dùng cho staff)
 *     responses:
 *       201:
 *         description: Tạo sự kiện thành công
 */
router.post("/", createEvent);

/**
 * @swagger
 * /api/events:
 *   get:
 *     summary: User xem danh sách sự kiện của mình
 *     tags: [Events]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Danh sách sự kiện của user
 */
router.get("/", getMyEvents);

/**
 * @swagger
 * /api/events/all:
 *   get:
 *     summary: Staff xem tất cả sự kiện (chỉ xem)
 *     tags: [Events]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Danh sách tất cả sự kiện
 */
router.get("/all", isStaff, getAllEvents);

/**
 * @swagger
 * /api/events/{id}:
 *   put:
 *     summary: Cập nhật sự kiện (chỉnh thời gian bắt đầu / kết thúc)
 *     description: |
 *       Cho phép chỉnh sửa thông tin sự kiện.
 *       Có thể chỉnh **startTime**, **endTime**, hoặc các trường khác.
 *       Thời gian phải theo chuẩn ISO-8601 và startTime < endTime.
 *     tags: [Events]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID của sự kiện
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *                 example: Họp cập nhật dự án
 *               description:
 *                 type: string
 *                 example: Dời lịch họp do thay đổi kế hoạch
 *               startTime:
 *                 type: string
 *                 format: date-time
 *                 example: 2026-01-15T08:00:00Z
 *               endTime:
 *                 type: string
 *                 format: date-time
 *                 example: 2026-01-15T10:00:00Z
 *     responses:
 *       200:
 *         description: Cập nhật sự kiện thành công
 *       400:
 *         description: Thời gian không hợp lệ
 *       404:
 *         description: Không tìm thấy sự kiện
 *       403:
 *         description: Không có quyền chỉnh sửa
 */
router.put("/:id", updateEvent);

/**
 * @swagger
 * /api/events/{id}:
 *   delete:
 *     summary: Staff xóa sự kiện do mình tạo
 *     tags: [Events]
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
 *       403:
 *         description: Không có quyền xóa
 */
router.delete("/:id", deleteEvent);

/**
 * @swagger
 * /api/events/{id}/hide:
 *   put:
 *     summary: Admin ẩn sự kiện vi phạm
 *     tags: [Events]
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
 *         description: Ẩn sự kiện thành công
 */
router.put("/:id/hide", isAdmin, hideEvent);

export default router;
