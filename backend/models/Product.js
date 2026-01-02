import mongoose from "mongoose";

const productSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    price: { type: Number, required: true },
    image: { type: String }, // link cloudinary
    description: { type: String },
  },
  { timestamps: true }
);

export default mongoose.model("Product", productSchema);
