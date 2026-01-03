// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:android_intent_plus/android_intent.dart';
//
// class AlarmScreen extends StatefulWidget {
//   const AlarmScreen({super.key});
//
//   @override
//   State<AlarmScreen> createState() => _AlarmScreenState();
// }
//
// class _AlarmScreenState extends State<AlarmScreen> {
//   TimeOfDay? _selectedTime;
//
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   bool _speechAvailable = false;
//   bool _isListening = false;
//   String _lastVoiceText = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }
//
//   Future<void> _initSpeech() async {
//     final hasSpeech = await _speech.initialize(
//       debugLogging: false,
//       onStatus: (s) => print("speech status: $s"),
//       onError: (e) {
//         print("speech error: ${e.errorMsg}");
//         setState(() => _isListening = false);
//       },
//       finalTimeout: const Duration(seconds: 2),
//     );
//
//     setState(() {
//       _speechAvailable = hasSpeech;
//     });
//   }
//
//   Future<void> _selectTime(BuildContext context) async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime ?? TimeOfDay.now(),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData(
//             colorScheme: ColorScheme.light(
//               primary: Colors.blue,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       setState(() => _selectedTime = picked);
//     }
//   }
//
//   Future<void> _setNativeAlarm() async {
//     if (_selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Vui lòng chọn giờ trước.")),
//       );
//       return;
//     }
//
//     final intent = AndroidIntent(
//       action: 'android.intent.action.SET_ALARM',
//       arguments: <String, dynamic>{
//         'android.intent.extra.alarm.HOUR': _selectedTime!.hour,
//         'android.intent.extra.alarm.MINUTES': _selectedTime!.minute,
//         'android.intent.extra.alarm.MESSAGE': 'Báo thức từ App của bạn',
//       },
//     );
//
//     try {
//       await intent.launch();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Đang mở ứng dụng Báo thức...'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Lỗi khi mở đồng hồ: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   Future<void> _openAlarmApp() async {
//     final intent = AndroidIntent(
//       action: 'android.intent.action.SHOW_ALARMS',
//     );
//     await intent.launch();
//   }
//
//   String formatTimeOfDay(TimeOfDay tod) {
//     final now = DateTime.now();
//     final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
//     return DateFormat.Hm().format(dt);
//   }
//
//   // ========== VOICE ==========
//   Future<void> _toggleVoiceInput() async {
//     if (!_speechAvailable) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Thiết bị không hỗ trợ Voice.")),
//       );
//       return;
//     }
//
//     if (_isListening) {
//       await _speech.stop();
//       setState(() => _isListening = false);
//       return;
//     }
//
//     final locale = await _speech.systemLocale();
//
//     setState(() => _isListening = true);
//
//     _speech.listen(
//       localeId: locale?.localeId ?? "vi_VN",
//       listenFor: const Duration(seconds: 7),
//       pauseFor: const Duration(seconds: 2),
//       onResult: (result) {
//         setState(() => _lastVoiceText = result.recognizedWords);
//
//         if (result.finalResult) {
//           _handleVoiceText(result.recognizedWords);
//           _speech.stop();
//           setState(() => _isListening = false);
//         }
//       },
//     );
//   }
//
//   void _handleVoiceText(String text) {
//     final time = _parseTimeFromText(text);
//
//     if (time == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Không hiểu giờ bạn nói.')),
//       );
//       return;
//     }
//
//     setState(() => _selectedTime = time);
//     _setNativeAlarm();
//   }
//
//   TimeOfDay? _parseTimeFromText(String text) {
//     final nums = RegExp(r'(\d{1,2})')
//         .allMatches(text)
//         .map((m) => int.parse(m.group(1)!))
//         .toList();
//
//     if (nums.isEmpty) return null;
//
//     final hour = nums[0];
//     final minute = nums.length > 1 ? nums[1] : 0;
//
//     if (hour > 23 || minute > 59) return null;
//
//     return TimeOfDay(hour: hour, minute: minute);
//   }
//
//   @override
//   void dispose() {
//     _speech.stop();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         elevation: 2,
//         backgroundColor: Colors.blue,
//         title: const Text(
//           "Đồng hồ báo thức",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: _toggleVoiceInput,
//             icon: Icon(
//               _isListening ? Icons.mic : Icons.mic_none,
//               color: _isListening ? Colors.redAccent : Colors.white,
//             ),
//             tooltip: "Đặt giờ bằng giọng nói",
//           ),
//         ],
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // CARD hiển thị giờ
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16)),
//               child: Container(
//                 padding: const EdgeInsets.all(24),
//                 width: double.infinity,
//                 child: Column(
//                   children: [
//                     const Text(
//                       "Giờ báo thức",
//                       style:
//                       TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       _selectedTime == null
//                           ? "-- : --"
//                           : formatTimeOfDay(_selectedTime!),
//                       style: const TextStyle(
//                         fontSize: 44,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 25),
//
//             ElevatedButton.icon(
//               onPressed: () => _selectTime(context),
//               icon: const Icon(Icons.access_time),
//               label: const Text(
//                 "Chọn giờ thủ công",
//                 style: TextStyle(fontSize: 18),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue.shade600,
//                 foregroundColor: Colors.white,
//                 minimumSize: const Size(double.infinity, 55),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             ElevatedButton.icon(
//               onPressed: _setNativeAlarm,
//               icon: const Icon(Icons.alarm),
//               label: const Text(
//                 "Đặt báo thức",
//                 style: TextStyle(fontSize: 18),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green.shade600,
//                 foregroundColor: Colors.white,
//                 minimumSize: const Size(double.infinity, 55),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             TextButton.icon(
//               onPressed: _openAlarmApp,
//               icon: const Icon(Icons.list_alt),
//               label: const Text("Xem danh sách báo thức"),
//             ),
//
//             const SizedBox(height: 20),
//
//             if (_lastVoiceText.isNotEmpty)
//               Text(
//                 "Bạn nói: $_lastVoiceText",
//                 style:
//                 const TextStyle(fontSize: 14, color: Colors.blueGrey),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
