import express from "express";
import {
  getAllUsers,
  disableUser,
  enableUser,
  getAssignableUsers,
  deleteUser,        // 👈 THÊM
} from "../controller/userController.js";

import {
  authenticate,
  isAdmin,
  isStaff,
} from "../middlewares/authMiddleware.js";

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Users
 *   description: Quản lý người dùng (Admin / Staff)
 */

router.use(authenticate);

/**
 * @swagger
 * /api/users/assignable:
 *   get:
 *     summary: STAFF lấy danh sách user để gán lịch
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Danh sách user (role = user, chưa bị khóa)
 */
router.get("/assignable", isStaff, getAssignableUsers);

/* ================= ADMIN ONLY ================= */
router.use(isAdmin);

/**
 * @swagger
 * /api/users:
 *   get:
 *     summary: ADMIN lấy danh sách user (chỉ role = user)
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Danh sách user
 */
router.get("/", getAllUsers);

/**
 * @swagger
 * /api/users/{id}/disable:
 *   put:
 *     summary: ADMIN khóa user
 *     tags: [Users]
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
 *         description: Khóa user thành công
 *       404:
 *         description: Không tìm thấy user
 */
router.put("/:id/disable", disableUser);

/**
 * @swagger
 * /api/users/{id}/enable:
 *   put:
 *     summary: ADMIN mở khóa user
 *     tags: [Users]
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
 *         description: Mở khóa user thành công
 *       404:
 *         description: Không tìm thấy user
 */
router.put("/:id/enable", enableUser);

/**
 * @swagger
 * /api/users/{id}:
 *   delete:
 *     summary: ADMIN xóa user (chỉ role = user)
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID của user
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Xóa user thành công
 *       404:
 *         description: Không tìm thấy user
 *       403:
 *         description: Không có quyền admin
 */
router.delete("/:id", deleteUser);

export default router;
