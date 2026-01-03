class Reminder {
  final String id;
  final DateTime remindAt;
  final String method;
  final String? eventId; // 👈 thêm

  Reminder({
    required this.id,
    required this.remindAt,
    required this.method,
    this.eventId,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['_id'],
      remindAt: DateTime.parse(json['remindAt']),
      method: json['method'] ?? 'notification',
      eventId: json['event'] is Map
          ? json['event']['_id']
          : json['event'],
    );
  }
}
