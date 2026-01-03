import 'package:flutter/material.dart';
import '../../models/AdminUser.dart';
import '../../service/admin_user_service.dart';

class AdminUserScreen extends StatefulWidget {
  const AdminUserScreen({super.key});

  @override
  State<AdminUserScreen> createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminUserScreen> {
  late Future<List<AdminUser>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    _usersFuture = AdminUserService.getAllUsers();
  }

  Future<void> _toggleUser(AdminUser user) async {
    try {
      if (user.isDisabled) {
        await AdminUserService.enableUser(user.id);
      } else {
        await AdminUserService.disableUser(user.id);
      }
      setState(_loadUsers);
    } catch (_) {
      _showError("Không thể cập nhật trạng thái user");
    }
  }

  Future<void> _confirmDeleteUser(AdminUser user) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa user"),
        content: Text("Bạn có chắc muốn xóa '${user.username}' không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Xóa"),
          ),
        ],
      ),
    );

    if (ok == true) {
      try {
        await AdminUserService.deleteUser(user.id);
        setState(_loadUsers);
      } catch (_) {
        _showError("Không thể xóa user");
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý User"),
      ),
      body: FutureBuilder<List<AdminUser>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Lỗi tải danh sách user"));
          }

          final users = snapshot.data!;
          if (users.isEmpty) {
            return const Center(child: Text("Không có user"));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (_, index) {
              final user = users[index];

              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(user.username),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.email),
                      Text("Role: ${user.role}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: !user.isDisabled,
                        activeColor: Colors.deepPurple,
                        inactiveThumbColor: Colors.grey,
                        onChanged: (_) => _toggleUser(user),
                      ),

                      IconButton(
                        icon:
                        const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDeleteUser(user),
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
