import 'package:flutter/material.dart';
import 'admin_user_screen.dart';
// sau này có thể thêm admin_event_screen.dart

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ADMIN")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminUserScreen(),
                  ),
                );
              },
              child: const Text("👥 Quản lý User"),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                // sau này làm hide event
              },
              child: const Text("🚫 Quản lý Sự kiện"),
            ),
          ],
        ),
      ),
    );
  }
}
