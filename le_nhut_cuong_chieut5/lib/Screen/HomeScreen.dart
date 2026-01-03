// import 'package:flutter/material.dart';
//
// // ===== SCREEN CŨ =====
// import 'YoutubePlayerScreen.dart';
// import 'TranslateScreen.dart';
// import 'AlarmScreen.dart';
// import 'product_screen.dart';
// import 'ProfileInfoScreen.dart';
// import 'group_info_screen.dart';
//
// // ===== SCREEN USER (MỚI) =====
// import 'user/event_list_screen.dart';
// import 'user/reminder_list_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//
//   // ⚠️ SỐ WIDGET = SỐ TAB
//   final List<Widget> _widgetOptions = <Widget>[
//     const EventListScreen(),        // 0 - Sự kiện
//     const ReminderListScreen(),     // 1 - Nhắc nhở
//     YoutubePlayerScreen(),          // 2 - Youtube
//     TranslateScreen(),              // 3 - Dịch
//     AlarmScreen(),                  // 4 - Báo thức
//     const ProductScreen(),          // 5 - Sản phẩm
//     const ProfileInfoScreen(),      // 6 - Cá nhân
//     const GroupInfoScreen(),        // 7 - Nhóm
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ứng dụng đa năng'),
//       ),
//       body: _widgetOptions[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.event),
//             label: 'Sự kiện',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.alarm_on),
//             label: 'Nhắc nhở',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.play_circle_filled),
//             label: 'Youtube',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.translate),
//             label: 'Dịch',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.alarm),
//             label: 'Báo thức',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_bag),
//             label: 'Sản phẩm',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Cá nhân',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.group),
//             label: 'Nhóm',
//           ),
//         ],
//       ),
//     );
//   }
// }
