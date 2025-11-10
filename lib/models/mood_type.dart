class MoodType {
  final String emoji;
  final String label;
  final bool isPositive;

  const MoodType({
    required this.emoji,
    required this.label,
    required this.isPositive,
  });

  static const List<MoodType> allMoods = [
    MoodType(emoji: '😊', label: 'Happy', isPositive: true),
    MoodType(emoji: '😎', label: 'Cool', isPositive: true),
    MoodType(emoji: '😔', label: 'Sad', isPositive: false),
    MoodType(emoji: '😡', label: 'Angry', isPositive: false),
    MoodType(emoji: '😰', label: 'Anxious', isPositive: false),
    MoodType(emoji: '😴', label: 'Tired', isPositive: false),
  ];

  static MoodType? fromEmoji(String emoji) {
    try {
      return allMoods.firstWhere((mood) => mood.emoji == emoji);
    } catch (e) {
      return null;
    }
  }
}
