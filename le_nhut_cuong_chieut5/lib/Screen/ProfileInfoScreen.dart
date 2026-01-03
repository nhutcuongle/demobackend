import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../helper/token_storage.dart';
import 'login_screen.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  String role = 'user';
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  /// Load username + role từ JWT
  Future<void> _loadUserInfo() async {
    final token = await TokenStorage.getToken();
    if (token == null) return;

    final payload = Jwt.parseJwt(token);

    setState(() {
      role = payload['role'] ?? 'user';
      username = payload['username'] ?? '';
    });
  }

  /// Gọi điện
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  /// Mở YouTube
  void _openYoutube() {
    const AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: 'https://www.youtube.com',
    );
    intent.launch();
  }

  /// LOGOUT
  Future<void> _logout(BuildContext context) async {
    await TokenStorage.clear();


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã đăng xuất')),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Cá Nhân'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Ảnh đại diện
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue.shade100,
                backgroundImage:
                const NetworkImage('https://via.placeholder.com/150'),
                child: const Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Username + role
            Text(
              username.isNotEmpty ? '$username ($role)' : '($role)',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              'Lớp: 22DTHB6',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            const Text(
              'MSSV: 2280600342',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // Liên hệ
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading:
                    const Icon(Icons.phone, color: Colors.green),
                    title: const Text('0817878151'),
                    onTap: () => _makePhoneCall('0817878151'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.red),
                    title: const Text('Mở YouTube'),
                    subtitle:
                    const Text('Nhấn để mở ứng dụng YouTube'),
                    onTap: _openYoutube,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Nút Đăng xuất
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Đăng xuất'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
