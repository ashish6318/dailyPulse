import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mood_entry.dart';
import '../models/mood_type.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final _authService = AuthService();
  final _localStorageService = LocalStorageService();

  List<MoodEntry> _moodEntries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMoodEntries();
  }

  void _loadMoodEntries() {
    setState(() => _isLoading = true);

    try {
      final userId = _authService.currentUser?.uid;
      if (userId != null) {
        _moodEntries = _localStorageService.getMoodEntriesByUserId(userId);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load entries: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Map<String, int> _getMoodCounts() {
    final counts = <String, int>{};
    for (var mood in MoodType.allMoods) {
      counts[mood.emoji] = 0;
    }
    for (var entry in _moodEntries) {
      counts[entry.mood] = (counts[entry.mood] ?? 0) + 1;
    }
    return counts;
  }

  int get _totalEntries => _moodEntries.length;

  int get _positiveDays => _moodEntries.where((e) => e.isPositive).length;

  int get _negativeDays => _moodEntries.where((e) => !e.isPositive).length;

  String get _mostCommonMood {
    if (_moodEntries.isEmpty) return 'N/A';

    final counts = _getMoodCounts();
    final maxEntry = counts.entries.reduce((a, b) => a.value > b.value ? a : b);

    return maxEntry.value > 0 ? maxEntry.key : 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_moodEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No data to analyze',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start logging your moods to see insights',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final moodCounts = _getMoodCounts();

    return RefreshIndicator(
      onRefresh: () async {
        _loadMoodEntries();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              'Your Mood Insights',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              'Track your emotional patterns',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Entries',
                    _totalEntries.toString(),
                    Icons.calendar_today,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Most Common',
                    _mostCommonMood,
                    Icons.favorite,
                    Colors.pink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Positive Days',
                    _positiveDays.toString(),
                    Icons.sentiment_satisfied_alt,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Negative Days',
                    _negativeDays.toString(),
                    Icons.sentiment_dissatisfied,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Mood Distribution Chart
            Text(
              'Mood Distribution',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      sections: _buildPieChartSections(moodCounts),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Mood Legend
            Text(
              'Mood Breakdown',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ...MoodType.allMoods.map((mood) {
              final count = moodCounts[mood.emoji] ?? 0;
              final percentage = _totalEntries > 0
                  ? (count / _totalEntries * 100).toStringAsFixed(1)
                  : '0.0';

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Text(
                    mood.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  title: Text(
                    mood.label,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        count.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
    Map<String, int> moodCounts,
  ) {
    final colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
    ];

    int index = 0;
    return MoodType.allMoods.map((mood) {
      final count = moodCounts[mood.emoji] ?? 0;
      final percentage = _totalEntries > 0
          ? (count / _totalEntries * 100)
          : 0.0;
      final color = colors[index % colors.length];
      index++;

      return PieChartSectionData(
        value: count.toDouble(),
        title: count > 0 ? '${percentage.toStringAsFixed(0)}%' : '',
        color: color,
        radius: 50,
        titleStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
