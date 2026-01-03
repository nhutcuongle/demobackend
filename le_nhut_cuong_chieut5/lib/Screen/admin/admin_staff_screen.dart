import 'package:flutter/material.dart';
import '../../models/AdminUser.dart';
import '../../service/admin_staff_service.dart';

class AdminStaffScreen extends StatefulWidget {
  const AdminStaffScreen({super.key});

  @override
  State<AdminStaffScreen> createState() => _AdminStaffScreenState();
}

class _AdminStaffScreenState extends State<AdminStaffScreen> {
  late Future<List<AdminUser>> _staffFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _staffFuture = AdminStaffService.getAllStaff();
  }

  Future<void> _toggleStaff(AdminUser staff) async {
    try {
      await AdminStaffService.updateStaff(
        id: staff.id,
        isDisabled: !staff.isDisabled,
      );
      setState(_reload);
    } catch (_) {
      _showError("Không thể cập nhật trạng thái staff");
    }
  }

  Future<void> _confirmDeleteStaff(AdminUser staff) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa staff"),
        content: Text("Bạn có chắc muốn xóa '${staff.username}' không?"),
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
        await AdminStaffService.deleteStaff(staff.id);
        setState(_reload);
      } catch (_) {
        _showError("Không thể xóa staff");
      }
    }
  }

  void _openCreateStaffDialog() async {
    await showDialog(
      context: context,
      builder: (_) => const _CreateStaffDialog(),
    );
    setState(_reload);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý Staff"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openCreateStaffDialog,
          )
        ],
      ),
      body: FutureBuilder<List<AdminUser>>(
        future: _staffFuture,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Lỗi tải staff"));
          }

          final staffList = snapshot.data!;
          if (staffList.isEmpty) {
            return const Center(child: Text("Chưa có staff"));
          }

          return ListView.builder(
            itemCount: staffList.length,
            itemBuilder: (_, i) {
              final staff = staffList[i];
              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(staff.username),
                  subtitle: Text(staff.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: !staff.isDisabled,
                        activeColor: Colors.deepPurple,
                        inactiveThumbColor: Colors.grey,
                        onChanged: (_) => _toggleStaff(staff),
                      ),

                      IconButton(
                        icon:
                        const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDeleteStaff(staff),
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

/* ================= DIALOG TẠO STAFF ================= */

class _CreateStaffDialog extends StatefulWidget {
  const _CreateStaffDialog();

  @override
  State<_CreateStaffDialog> createState() => _CreateStaffDialogState();
}

class _CreateStaffDialogState extends State<_CreateStaffDialog> {
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _loading = false;

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await AdminStaffService.createStaff(
        username: _usernameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("➕ Tạo Staff"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _usernameCtrl,
            decoration: const InputDecoration(labelText: "Username"),
          ),
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: _passwordCtrl,
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const CircularProgressIndicator()
              : const Text("Tạo"),
        ),
      ],
    );
  }
}
