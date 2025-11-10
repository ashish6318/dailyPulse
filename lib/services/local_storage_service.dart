import 'package:hive_flutter/hive_flutter.dart';
import '../models/mood_entry.dart';

class LocalStorageService {
  static const String _moodBoxName = 'moods';
  static const String _settingsBoxName = 'settings';

  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MoodEntryAdapter());
    await Hive.openBox<MoodEntry>(_moodBoxName);
    await Hive.openBox(_settingsBoxName);
  }

  // Get mood box
  Box<MoodEntry> get moodBox => Hive.box<MoodEntry>(_moodBoxName);

  // Get settings box
  Box get settingsBox => Hive.box(_settingsBoxName);

  // Save mood entry
  Future<void> saveMoodEntry(MoodEntry entry) async {
    await moodBox.put(entry.id, entry);
  }

  // Get all mood entries
  List<MoodEntry> getAllMoodEntries() {
    return moodBox.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get mood entries for a specific user
  List<MoodEntry> getMoodEntriesByUserId(String userId) {
    return moodBox.values.where((entry) => entry.userId == userId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Delete mood entry
  Future<void> deleteMoodEntry(String id) async {
    await moodBox.delete(id);
  }

  // Clear all mood entries
  Future<void> clearAllMoods() async {
    await moodBox.clear();
  }

  // Dark mode settings
  bool get isDarkMode => settingsBox.get('isDarkMode', defaultValue: false);

  Future<void> setDarkMode(bool value) async {
    await settingsBox.put('isDarkMode', value);
  }

  // Get last sync time
  DateTime? get lastSyncTime {
    final timestamp = settingsBox.get('lastSyncTime');
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }

  Future<void> setLastSyncTime(DateTime time) async {
    await settingsBox.put('lastSyncTime', time.toIso8601String());
  }

  // Get user ID
  String? get userId => settingsBox.get('userId');

  Future<void> setUserId(String? id) async {
    if (id == null) {
      await settingsBox.delete('userId');
    } else {
      await settingsBox.put('userId', id);
    }
  }
}
