import 'package:flutter/material.dart';
import '../helper/token_storage.dart';
import 'admin/admin_screen.dart';
import 'login_screen.dart';

import 'main_screen.dart';
import 'staff/staff_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isLoggedIn = await TokenStorage.isLoggedIn();
    if (!isLoggedIn) {
      _go(const LoginScreen());
      return;
    }

    final role = await TokenStorage.getRole();

    _go(MainScreen(role: role ?? "user"));


  }

  void _go(Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => screen),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
