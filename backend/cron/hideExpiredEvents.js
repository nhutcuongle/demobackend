import cron from "node-cron";
import Event from "../models/Event.js";

const hideExpiredEvents = () => {
  // ⏰ chạy mỗi 1 phút
  cron.schedule("*/1 * * * *", async () => {
    try {
      const now = new Date();

      const result = await Event.updateMany(
        {
          endTime: { $lt: now },
          isHidden: false, // chỉ ẩn những event chưa bị ẩn
        },
        {
          $set: { isHidden: true },
        }
      );

      if (result.modifiedCount > 0) {
        console.log(
          `[CRON] Hidden ${result.modifiedCount} expired events at ${now.toISOString()}`
        );
      }
    } catch (err) {
      console.error("[CRON] Hide expired events error:", err);
    }
  });
};

export default hideExpiredEvents;
