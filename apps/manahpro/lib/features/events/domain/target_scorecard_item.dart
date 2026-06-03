import '../../scoring/domain/scoring_entities.dart';

class TargetScorecardItem {
  const TargetScorecardItem({
    required this.registrationId,
    this.bibNumber,
    required this.targetButt,
    required this.targetLetter,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.scoringSession,
  });

  final String registrationId;
  final String? bibNumber;
  final int targetButt;
  final String targetLetter;
  final int userId;
  final String userName;
  final String? userAvatarUrl;
  final ScoringSessionEntity scoringSession;
}
