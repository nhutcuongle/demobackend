// import 'package:flutter/material.dart';
//
// class Member {
//   final String name;
//   final String id;
//   final String role;
//   final String imageUrl;
//
//   Member({
//     required this.name,
//     required this.id,
//     required this.role,
//     required this.imageUrl,
//   });
// }
//
// class GroupInfoScreen extends StatefulWidget {
//   const GroupInfoScreen({super.key});
//
//   @override
//   State<GroupInfoScreen> createState() => _GroupInfoScreenState();
// }
//
// class _GroupInfoScreenState extends State<GroupInfoScreen> {
//   final PageController _pageController = PageController(viewportFraction: 0.85);
//  
//   // Danh sách thành viên mẫu
//   final List<Member> _members = [
//     Member(
//       name: 'Trịnh Minh Đạt',
//       id: '20xxxxxxxx',
//       role: 'Nhóm trưởng',
//       imageUrl: 'https://via.placeholder.com/150', // Thay bằng đường dẫn ảnh thật hoặc asset
//     ),
//     Member(
//       name: 'Lê Nhựt Cường',
//       id: '20xxxxxxxx',
//       role: 'Thành viên',
//       imageUrl: 'https://via.placeholder.com/150',
//     ),
//     Member(
//       name: 'Lê Trung Dũng',
//       id: '20xxxxxxxx',
//       role: 'Thành viên',
//       imageUrl: 'https://via.placeholder.com/150',
//     ),
//     Member(
//       name: 'La Minh Quân ',
//       id: '20xxxxxxxx',
//       role: 'Thành viên',
//       imageUrl: 'https://via.placeholder.com/150',
//     ),
//     Member(
//       name: 'Trần Đăng Khoa',
//       id: '20xxxxxxxx',
//       role: 'Thành viên',
//       imageUrl: 'https://via.placeholder.com/150',
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Thông tin nhóm')),
//       body: Column(
//         children: [
//           const SizedBox(height: 20),
//           const Text(
//             'Danh sách thành viên',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: PageView.builder(
//               controller: _pageController,
//               itemCount: _members.length,
//               itemBuilder: (context, index) {
//                 final member = _members[index];
//                 return _buildMemberCard(member);
//               },
//             ),
//           ),
//           const SizedBox(height: 50),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMemberCard(Member member) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 60,
//               backgroundColor: Colors.blue.shade100,
//               backgroundImage: NetworkImage(member.imageUrl),
//               onBackgroundImageError: (_, __) {
//                 // Fallback nếu load ảnh lỗi
//               },
//               child: const Icon(Icons.person, size: 60, color: Colors.grey),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               member.name,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'MSSV: ${member.id}',
//               style: const TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//             const SizedBox(height: 10),
//             Chip(
//               label: Text(member.role),
//               backgroundColor: Colors.blue.shade50,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
