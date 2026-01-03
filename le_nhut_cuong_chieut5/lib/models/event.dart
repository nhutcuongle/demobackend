

class Event {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? ownerName;
  final String? createdById;
  final String? createdByRole;

  Event({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.ownerName,
    this.createdById,
    this.createdByRole,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      ownerName: json['owner'] is Map ? json['owner']['username'] : null,
      createdById: json['createdBy'] is Map ? json['createdBy']['_id'] : null,
      createdByRole:
      json['createdBy'] is Map ? json['createdBy']['role'] : null,
    );
  }
}
