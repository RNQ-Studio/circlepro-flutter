class EventLeaderboardEntry {
  const EventLeaderboardEntry({
    required this.sessionId,
    required this.userId,
    required this.userName,
    this.bibNumber,
    this.targetButt,
    this.targetLetter,
    required this.totalScore,
    required this.xCount,
    required this.tenCount,
    required this.missCount,
    required this.arrowsShot,
    required this.avgPerArrow,
  });

  final String sessionId;
  final int userId;
  final String userName;
  final String? bibNumber;
  final int? targetButt;
  final String? targetLetter;
  final int totalScore;
  final int xCount;
  final int tenCount;
  final int missCount;
  final int arrowsShot;
  final double avgPerArrow;
}
