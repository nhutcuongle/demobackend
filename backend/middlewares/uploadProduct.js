import multer from "multer";
import { storage } from "../config/cloudinary.js";

const uploadProductImage = multer({
  storage,
});

export default uploadProductImage;
