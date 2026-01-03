  // import 'package:flutter/material.dart';
  // import '../../models/event.dart';
  // import '../../service/event_service.dart';
  //
  // class AllEventScreen extends StatefulWidget {
  //   const AllEventScreen({super.key});
  //
  //   @override
  //   State<AllEventScreen> createState() => _AllEventScreenState();
  // }
  //
  // class _AllEventScreenState extends State<AllEventScreen> {
  //   late Future<List<Event>> futureEvents;
  //
  //   @override
  //   void initState() {
  //     super.initState();
  //     futureEvents = EventService.getAllEvents();
  //   }
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       appBar: AppBar(title: const Text("Tất cả sự kiện")),
  //       body: FutureBuilder<List<Event>>(
  //         future: futureEvents,
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return const Center(child: CircularProgressIndicator());
  //           }
  //
  //           if (snapshot.hasError) {
  //             return Center(
  //               child: Text(snapshot.error.toString()),
  //             );
  //           }
  //
  //           final events = snapshot.data!;
  //           if (events.isEmpty) {
  //             return const Center(child: Text("Không có sự kiện"));
  //           }
  //
  //           return ListView.builder(
  //             itemCount: events.length,
  //             itemBuilder: (_, i) {
  //               final e = events[i];
  //               return Card(
  //                 child: ListTile(
  //                   title: Text(e.title),
  //                   subtitle: Text(
  //                     "Người tạo: ${e.ownerName ?? '---'}\n"
  //                         "${e.startTime} → ${e.endTime}",
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //         },
  //       ),
  //     );
  //   }
  // }

  import 'package:flutter/material.dart';
  import '../../models/event.dart';
  import '../../service/event_service.dart';
  import 'create_event_for_user_screen.dart';

  class AllEventScreen extends StatefulWidget {
    const AllEventScreen({super.key});

    @override
    State<AllEventScreen> createState() => _AllEventScreenState();
  }

  class _AllEventScreenState extends State<AllEventScreen> {
    late Future<List<Event>> futureEvents;

    @override
    void initState() {
      super.initState();
      _load();
    }

    void _load() {
      setState(() {
        futureEvents = EventService.getAllEvents();
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tất cả sự kiện"),
          actions: [
            // ➕ STAFF tạo sự kiện cho user
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final created = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateEventForUserScreen(),
                  ),
                );

                if (created == true) {
                  _load();
                }
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Event>>(
          future: futureEvents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final events = snapshot.data!;
            if (events.isEmpty) {
              return const Center(child: Text("Không có sự kiện"));
            }

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
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }
