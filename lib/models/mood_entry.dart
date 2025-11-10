import 'package:hive/hive.dart';

part 'mood_entry.g.dart';

@HiveType(typeId: 0)
class MoodEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String mood; // 😊, 😔, 😡, 😰, 😴, 😎

  @HiveField(3)
  String note;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  bool isPositive;

  MoodEntry({
    required this.id,
    required this.userId,
    required this.mood,
    required this.note,
    required this.date,
    required this.isPositive,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'mood': mood,
      'note': note,
      'date': date.toIso8601String(),
      'isPositive': isPositive,
    };
  }

  // Create from Firestore Map
  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      mood: map['mood'] ?? '😊',
      note: map['note'] ?? '',
      date: DateTime.parse(map['date']),
      isPositive: map['isPositive'] ?? true,
    );
  }

  // Copy with method for updates
  MoodEntry copyWith({
    String? id,
    String? userId,
    String? mood,
    String? note,
    DateTime? date,
    bool? isPositive,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      date: date ?? this.date,
      isPositive: isPositive ?? this.isPositive,
    );
  }
}
