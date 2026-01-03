import 'package:flutter/material.dart';
import '../helper/token_storage.dart';

// USER SCREENS
import 'admin/admin_staff_screen.dart';
import 'admin/admin_user_screen.dart';
import 'user/event_list_screen.dart';
import 'user/reminder_list_screen.dart';

// COMMON
import 'ProfileInfoScreen.dart';

// STAFF / ADMIN
import 'staff/all_event_screen.dart';

class MainScreen extends StatefulWidget {
  final String role;
  const MainScreen({super.key, required this.role});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  late final List<Widget> _tabs;
  late final List<BottomNavigationBarItem> _items;

  @override
  void initState() {
    super.initState();
    _buildByRole();
  }

  void _buildByRole() {
    if (widget.role == "user") {
      _tabs = const [
        EventListScreen(),
        ReminderListScreen(),
        ProfileInfoScreen(),
      ];

      _items = const [
        BottomNavigationBarItem(icon: Icon(Icons.event), label: "Sự kiện"),
        BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "Nhắc nhở"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
      ];
    }
    else if (widget.role == "staff") {
      _tabs = const [
        EventListScreen(),
        ProfileInfoScreen(),
      ];

      _items = const [
        BottomNavigationBarItem(icon: Icon(Icons.event), label: "Sự kiện"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
      ];
    }
    else if (widget.role == "admin") {
      _tabs = const [
        AdminUserScreen(),
        AdminStaffScreen(),
        ProfileInfoScreen(),
      ];

      _items = const [
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "User"),
        BottomNavigationBarItem(icon: Icon(Icons.badge), label: "Staff"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.role.toUpperCase()),
      ),
      body: _tabs[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: _items,
      ),
    );
  }
}
