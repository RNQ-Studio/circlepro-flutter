import '../../scoring/data/scoring_session_mapper.dart';
import '../domain/target_scorecard_item.dart';

TargetScorecardItem targetScorecardItemFromJson(Map<String, dynamic> json) {
  final user = json['user'] as Map<String, dynamic>;
  final scoringSessionJson = json['scoring_session'] as Map<String, dynamic>;

  return TargetScorecardItem(
    registrationId: json['registration_id'] as String,
    bibNumber: json['bib_number'] as String?,
    targetButt: json['target_butt'] as int,
    targetLetter: json['target_letter'] as String,
    userId: user['id'] as int,
    userName: user['name'] as String,
    userAvatarUrl: user['avatar_url'] as String?,
    scoringSession: scoringSessionFromJson(scoringSessionJson),
  );
}
