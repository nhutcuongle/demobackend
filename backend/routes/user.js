import express from "express";
import {
  getAllUsers,
  disableUser,
  enableUser,
} from "../controller/userController.js";

import { authenticate, isAdmin } from "../middlewares/authMiddleware.js";

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Users
 *   description: Quản lý người dùng (Admin)
 */

router.use(authenticate);
router.use(isAdmin);

/**
 * @swagger
 * /api/users:
 *   get:
 *     summary: ADMIN lấy danh sách tất cả user
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
 */
router.put("/:id/enable", enableUser);

export default router;
