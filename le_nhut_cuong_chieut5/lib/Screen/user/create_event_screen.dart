
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../service/event_service.dart';
import '../../service/notification_service.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? startTime;
  DateTime? endTime;
  bool isLoading = false;

  final _format = DateFormat('dd/MM/yyyy – HH:mm');

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

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
              )
            ],
          ),
        );
      },
    );
  }

  // ================= PICK START =================
  Future<void> pickStart() async {
    final now = DateTime.now();

    await _pickDateTime(
      initial: startTime ?? now,
      minimum: now,
      onConfirm: (dt) {
        setState(() {
          startTime = dt;

          // reset end nếu không hợp lệ
          if (endTime != null && !endTime!.isAfter(startTime!)) {
            endTime = null;
          }
        });
      },
    );
  }

  // ================= PICK END =================
  Future<void> pickEnd() async {
    if (startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Chọn thời gian bắt đầu trước")),
      );
      return;
    }

    await _pickDateTime(
      initial: endTime ?? startTime!.add(const Duration(minutes: 30)),
      minimum: startTime!.add(const Duration(minutes: 1)),
      onConfirm: (dt) {
        if (!dt.isAfter(startTime!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Thời gian kết thúc phải sau thời gian bắt đầu"),
            ),
          );
          return;
        }
        setState(() => endTime = dt);
      },
    );
  }

  // ================= SUBMIT =================
  Future<void> submit() async {
    if (titleController.text.trim().isEmpty ||
        startTime == null ||
        endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đủ thông tin")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await EventService.createEvent(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        startTime: startTime!,
        endTime: endTime!,
      );
      await NotificationService.scheduleEventNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: titleController.text.trim(),
        body: descriptionController.text.trim(),
        time: startTime!,
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tạo sự kiện")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Tiêu đề",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Mô tả",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // START
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text("Bắt đầu"),
              subtitle: Text(
                startTime == null
                    ? "Chưa chọn"
                    : _format.format(startTime!),
              ),
              trailing: const Icon(Icons.schedule),
              onTap: pickStart,
            ),

            // END
            ListTile(
              leading: const Icon(Icons.stop),
              title: const Text("Kết thúc"),
              subtitle: Text(
                endTime == null
                    ? "Chưa chọn"
                    : _format.format(endTime!),
              ),
              trailing: const Icon(Icons.schedule),
              onTap: pickEnd,
            ),

            const SizedBox(height: 32),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: isLoading ? null : submit,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Tạo sự kiện"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
