



import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../service/notification_service.dart';
import '../../service/reminder_service.dart';

class CreateReminderScreen extends StatefulWidget {
  final String eventId;
  final DateTime startTime;

  const CreateReminderScreen({
    super.key,
    required this.eventId,
    required this.startTime,
  });

  @override
  State<CreateReminderScreen> createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends State<CreateReminderScreen> {
  DateTime? remindAt;
  bool isLoading = false;

  final _format = DateFormat('dd/MM/yyyy – HH:mm');

  // ================= SPINNER PICKER =================
  Future<void> _pickDateTime({
    required DateTime initial,
    required DateTime minimum,
    required ValueChanged<DateTime> onConfirm,
  }) async {
    DateTime temp = initial;

    await showModalBottomSheet(
      context: context,
      builder: (_) {
        return SizedBox(
          height: 320,
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  use24hFormat: true,
                  initialDateTime: initial,
                  minimumDate: minimum,
                  onDateTimeChanged: (dt) => temp = dt,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm(temp);
                    },
                    child: const Text("Xác nhận"),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= PICK REMINDER TIME =================
  Future<void> pickReminderTime() async {
    final now = DateTime.now();

    await _pickDateTime(
      initial: remindAt ?? now,
      minimum: now,
      onConfirm: (dt) {
        if (!dt.isBefore(widget.startTime)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Thời gian nhắc phải trước thời gian bắt đầu sự kiện",
              ),
            ),
          );
          return;
        }

        setState(() => remindAt = dt);
      },
    );
  }

  // ================= SUBMIT =================
  Future<void> submit() async {
    if (remindAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn thời gian nhắc")),
      );
      return;
    }

    if (!remindAt!.isAfter(DateTime.now()) ||
        !remindAt!.isBefore(widget.startTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thời gian nhắc không hợp lệ")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // 1️⃣ LƯU DB
      await ReminderService.createReminder(
        eventId: widget.eventId,
        remindAt: remindAt!,
      );

      // 2️⃣ SCHEDULE NOTIFICATION (RUNG)
      await NotificationService.scheduleReminderNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: "Nhắc nhở sự kiện",
        body: "Sự kiện sắp bắt đầu",
        time: remindAt!,
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tạo nhắc nhở thất bại")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tạo nhắc nhở")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.alarm),
              title: const Text("Thời gian nhắc"),
              subtitle: Text(
                remindAt == null
                    ? "Chưa chọn"
                    : _format.format(remindAt!),
              ),
              trailing: const Icon(Icons.schedule),
              onTap: pickReminderTime,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: isLoading ? null : submit,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Tạo nhắc nhở"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
