import 'package:flutter/material.dart';
import 'all_event_screen.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("STAFF")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AllEventScreen(),
              ),
            );
          },
          child: const Text("Xem tất cả sự kiện"),
        ),
      ),
    );
  }
}
