import 'package:flutter/material.dart';
import '../../models/reminder.dart';
import '../../service/reminder_service.dart';


class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  late Future<List<Reminder>> future;

  @override
  void initState() {
    super.initState();
    future = ReminderService.getMyReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nhắc nhở")),
      body: FutureBuilder<List<Reminder>>(
        future: future,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Chưa có nhắc nhở"));
          }

          final reminders = snapshot.data!;
          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (_, i) {
              final r = reminders[i];
              return ListTile(
                title: Text("Nhắc lúc: ${r.remindAt}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await ReminderService.deleteReminder(r.id);
                    setState(() {
                      future = ReminderService.getMyReminders();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
