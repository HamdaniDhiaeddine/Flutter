
class Room {
  final String id;
  final String name;
  final String type;
  final Map<String, dynamic>? createdBy;
  final int participantsCount;
  final String? subject;
  final int capacity;
  final bool videoSessionActive;
  final DateTime createdAt;
  final String? password;

  Room({
    required this.id,
    required this.name,
    required this.type,
    this.createdBy,
    this.participantsCount = 0,
    this.subject,
    this.capacity = 10,
    this.videoSessionActive = false,
    required this.createdAt,
    this.password,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'public',
      createdBy: json['createdBy'],
      participantsCount: json['participantsCount'] ?? 0,
      subject: json['subject'],
      capacity: json['capacity'] ?? 10,
      videoSessionActive: json['videoSessionActive'] ?? false,
      createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt']) 
        : DateTime.now(),
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'createdBy': createdBy,
      'participantsCount': participantsCount,
      'subject': subject,
      'capacity': capacity,
      'videoSessionActive': videoSessionActive,
      'createdAt': createdAt.toIso8601String(),
      'password': password,
    };
  }
}