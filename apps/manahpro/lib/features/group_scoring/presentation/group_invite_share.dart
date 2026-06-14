import 'package:share_plus/share_plus.dart';

import '../domain/group_entities.dart';
import '../domain/join_link.dart';

/// Share a Latihan Bersama invite (Sprint 09, K6): the **link is the hero**
/// (tappable inside WhatsApp) and the typed code rides along as a fallback.
Future<void> shareGroupInvite(ScoringGroupEntity group) {
  return SharePlus.instance.share(
    ShareParams(
      subject: group.title?.isNotEmpty == true ? group.title : 'Latihan Bersama',
      text: JoinLink.shareMessage(code: group.joinCode, title: group.title),
    ),
  );
}
