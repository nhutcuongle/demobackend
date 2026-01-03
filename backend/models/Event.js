import mongoose from "mongoose";

const eventSchema = new mongoose.Schema(
  {
    title: { type: String, required: true },
    description: String,

    startTime: { type: Date, required: true },
    endTime: { type: Date, required: true },

    location: String,

    owner: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    isHidden: { type: Boolean, default: false }, // admin có thể ẩn
  },
  { timestamps: true }
);

export default mongoose.model("Event", eventSchema);
