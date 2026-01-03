import express from "express";
import {
  createEvent,
  getMyEvents,
  updateEvent,
  deleteEvent,
  hideEvent,
  getAllEvents,
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
 *     summary: Tạo sự kiện mới
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
 *                 example: Họp nhóm
 *               description:
 *                 type: string
 *                 example: Họp sprint tuần
 *               startTime:
 *                 type: string
 *                 format: date-time
 *                 example: 2026-01-10T09:00:00Z
 *               endTime:
 *                 type: string
 *                 format: date-time
 *                 example: 2026-01-10T10:00:00Z
 *     responses:
 *       201:
 *         description: Tạo sự kiện thành công
 */
router.post("/", createEvent);

/**
 * @swagger
 * /api/events:
 *   get:
 *     summary: Lấy danh sách sự kiện của tôi
 *     tags: [Events]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Danh sách sự kiện
 */
router.get("/", getMyEvents);

/**
 * @swagger
 * /api/events/all:
 *   get:
 *     summary: STAFF + ADMIN xem tất cả sự kiện
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
 *     summary: Cập nhật sự kiện của tôi
 *     tags: [Events]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
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
 *                 example: Họp cập nhật
 *               description:
 *                 type: string
 *                 example: Họp update tiến độ
 *               startTime:
 *                 type: string
 *                 format: date-time
 *                 example: 2026-01-10T09:00:00Z
 *               endTime:
 *                 type: string
 *                 format: date-time
 *                 example: 2026-01-10T10:00:00Z
 *     responses:
 *       200:
 *         description: Cập nhật thành công
 */
router.put("/:id", updateEvent);

/**
 * @swagger
 * /api/events/{id}:
 *   delete:
 *     summary: Xóa sự kiện của tôi
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
 */
router.delete("/:id", deleteEvent);

/**
 * @swagger
 * /api/events/{id}/hide:
 *   put:
 *     summary: ADMIN ẩn sự kiện
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
 *         description: Ẩn thành công
 */
router.put("/:id/hide", isAdmin, hideEvent);

export default router;
