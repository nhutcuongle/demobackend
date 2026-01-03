
import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../service/event_service.dart';
import '../../helper/token_storage.dart';

import '../staff/create_event_for_user_screen.dart';
import 'create_event_screen.dart';
import 'create_reminder_screen.dart';
import 'edit_event_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  Future<List<Event>>? futureEvents;

  String? role;
  String? myUserId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loadedRole = await TokenStorage.getRole();
    final loadedUserId = await TokenStorage.getUserId();

    if (!mounted) return;

    setState(() {
      role = loadedRole;
      myUserId = loadedUserId;

      if (role == "staff" || role == "admin") {
        futureEvents = EventService.getAllEvents();
      } else {
        futureEvents = EventService.getMyEvents();
      }
    });
  }

  // ================= HELPER =================
  bool createdByMe(Event e) => e.createdById == myUserId;
  bool createdByUser(Event e) => e.createdByRole == "user";
  bool createdByStaff(Event e) => e.createdByRole == "staff";

  // ================= PERMISSION =================
  bool canEditOrDelete(Event e) {
    if (role == "staff") {
      return createdByStaff(e) && createdByMe(e);
    }

    if (role == "user") {
      return createdByUser(e) && createdByMe(e);
    }

    return false;
  }

  bool canReminder(Event e) {
    if (role == "staff") return false;
    if (role == "user") return true;
    return false;
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          role == "staff" || role == "admin"
              ? "Tất cả Lịch"
              : "Lịch của tôi",
        ),
        actions: [
          if (role == "user" || role == "staff")
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final created = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      if (role == "staff") {
                        return const CreateEventForUserScreen();
                      } else {
                        return const CreateEventScreen();
                      }
                    },
                  ),
                );

                if (created == true) _load();
              },
            ),
        ],

      ),
      body: futureEvents == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có sự kiện"));
          }

          final events = snapshot.data!;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (_, i) {
              final e = events[i];

              return Card(
                child: ListTile(
                  title: Text(e.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${e.startTime} → ${e.endTime}"),
                      if (e.ownerName != null)
                        Text(
                          "User: ${e.ownerName}",
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (canReminder(e))
                        IconButton(
                          icon: const Icon(
                            Icons.alarm,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CreateReminderScreen(
                                  eventId: e.id,
                                  startTime: e.startTime,
                                ),
                              ),
                            );
                          },
                        ),

                      if (canEditOrDelete(e))
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditEventScreen(event: e),
                              ),
                            );
                            if (updated == true) _load();
                          },
                        ),

                      if (canEditOrDelete(e))
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await EventService.deleteEvent(e.id);
                            _load();
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
