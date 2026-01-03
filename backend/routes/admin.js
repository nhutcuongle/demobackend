import express from "express";
import {
  getAllStaff,
  createStaff,
  updateStaff,
  deleteStaff,
} from "../controller/adminController.js";

import { authenticate, isAdmin } from "../middlewares/authMiddleware.js";

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Admin
 *   description: Quản lý tài khoản staff (Admin only)
 */

router.use(authenticate, isAdmin);

/**
 * @swagger
 * /api/admin/staff:
 *   get:
 *     summary: Admin xem danh sách staff
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Danh sách staff
 *       401:
 *         description: Chưa đăng nhập
 *       403:
 *         description: Không có quyền admin
 */
router.get("/staff", getAllStaff);

/**
 * @swagger
 * /api/admin/staff:
 *   post:
 *     summary: Admin tạo tài khoản staff
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - username
 *               - email
 *               - password
 *             properties:
 *               username:
 *                 type: string
 *                 example: staff01
 *               email:
 *                 type: string
 *                 example: staff01@gmail.com
 *               password:
 *                 type: string
 *                 example: 123456
 *     responses:
 *       201:
 *         description: Tạo staff thành công
 *       400:
 *         description: Email đã tồn tại
 *       401:
 *         description: Chưa đăng nhập
 *       403:
 *         description: Không có quyền admin
 */
router.post("/staff", createStaff);

/**
 * @swagger
 * /api/admin/staff/{id}:
 *   put:
 *     summary: Admin cập nhật thông tin staff
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID của staff
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               username:
 *                 type: string
 *                 example: staff_new
 *               email:
 *                 type: string
 *                 example: staff_new@gmail.com
 *               password:
 *                 type: string
 *                 example: 123456
 *               isDisabled:
 *                 type: boolean
 *                 example: false
 *     responses:
 *       200:
 *         description: Cập nhật staff thành công
 *       404:
 *         description: Không tìm thấy staff
 *       401:
 *         description: Chưa đăng nhập
 *       403:
 *         description: Không có quyền admin
 */
router.put("/staff/:id", updateStaff);

/**
 * @swagger
 * /api/admin/staff/{id}:
 *   delete:
 *     summary: Admin xóa tài khoản staff
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID của staff
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Xóa staff thành công
 *       404:
 *         description: Không tìm thấy staff
 *       401:
 *         description: Chưa đăng nhập
 *       403:
 *         description: Không có quyền admin
 */
router.delete("/staff/:id", deleteStaff);

export default router;
