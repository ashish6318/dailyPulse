import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mood_entry.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save mood entry to Firestore
  Future<void> saveMoodEntry(MoodEntry entry) async {
    try {
      await _firestore
          .collection('users')
          .doc(entry.userId)
          .collection('moods')
          .doc(entry.id)
          .set(entry.toMap());
    } catch (e) {
      throw 'Failed to save mood entry: $e';
    }
  }

  // Get all mood entries for a user
  Future<List<MoodEntry>> getMoodEntries(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('moods')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MoodEntry.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'Failed to load mood entries: $e';
    }
  }

  // Get mood entries stream for real-time updates
  Stream<List<MoodEntry>> getMoodEntriesStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('moods')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MoodEntry.fromMap(doc.data()))
              .toList(),
        );
  }

  // Delete mood entry
  Future<void> deleteMoodEntry(String userId, String entryId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('moods')
          .doc(entryId)
          .delete();
    } catch (e) {
      throw 'Failed to delete mood entry: $e';
    }
  }

  // Update mood entry
  Future<void> updateMoodEntry(MoodEntry entry) async {
    try {
      await _firestore
          .collection('users')
          .doc(entry.userId)
          .collection('moods')
          .doc(entry.id)
          .update(entry.toMap());
    } catch (e) {
      throw 'Failed to update mood entry: $e';
    }
  }

  // Sync local entries to Firestore
  Future<void> syncMoodEntries(List<MoodEntry> entries) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (var entry in entries) {
        DocumentReference docRef = _firestore
            .collection('users')
            .doc(entry.userId)
            .collection('moods')
            .doc(entry.id);
        batch.set(docRef, entry.toMap());
      }

      await batch.commit();
    } catch (e) {
      throw 'Failed to sync mood entries: $e';
    }
  }
}
