import mongoose from "mongoose";

const reminderSchema = new mongoose.Schema(
  {
    event: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Event",
      required: true,
    },

    remindAt: { type: Date, required: true },

    method: {
      type: String,
      enum: ["notification", "email"],
      default: "notification",
    },

    owner: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
  },
  { timestamps: true }
);

export default mongoose.model("Reminder", reminderSchema);
