import 'package:flutter/material.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/group_entities.dart';
import '../../domain/group_leaderboard.dart';

/// Branded, shareable **group result card** (Sprint 07, task 7.4) — the artefact
/// that starts the circle when Coach Hadi drops it into the WhatsApp group.
///
/// Rendered at a fixed width and captured to PNG via a RepaintBoundary (same
/// pattern as the individual [Scorecard], reused here for the binder). It is
/// deliberately **DNF-friendly**: archers who didn't finish show "belum selesai"
/// (or "—" if they never started), never a shaming 0. A small ManahPro
/// watermark sits at the corners — the seed of the viral loop.
class GroupResultCard extends StatelessWidget {
  const GroupResultCard({
    super.key,
    required this.group,
    required this.leaderboard,
  });

  final ScoringGroupEntity group;
  final GroupLeaderboard leaderboard;

  @override
  Widget build(BuildContext context) {
    final entries = leaderboard.entries;
    final d = group.startedAt.toLocal();
    final dateStr = '${d.day}/${d.month}/${d.year}';
    final title =
        group.title?.isNotEmpty == true ? group.title! : 'Latihan Bersama';

    return Container(
      width: 360,
      padding: const EdgeInsets.all(ManahSpacing.lg),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ManahColors.brand, Color(0xFF1B5E20)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.track_changes, color: Colors.white, size: 22),
              const SizedBox(width: ManahSpacing.sm),
              const Text(
                'ManahPro',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              if (leaderboard.inProgress)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ManahColors.amber,
                    borderRadius: BorderRadius.circular(ManahRadius.full),
                  ),
                  child: const Text(
                    'SEMENTARA',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
                  ),
                ),
            ],
          ),
          const SizedBox(height: ManahSpacing.lg),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 24,
              height: 1.1,
            ),
          ),
          const SizedBox(height: ManahSpacing.xs),
          Text(
            '${group.roundPresetLabel ?? '${group.distanceM} m'} · '
            '${group.countedEndCount}×${group.arrowsPerEnd} skor · '
            '${group.environment.label}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: ManahSpacing.lg),
          if (entries.isEmpty)
            const Text(
              'Belum ada peserta.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            )
          else
            for (final e in entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _ResultRow(entry: e),
              ),
          const SizedBox(height: ManahSpacing.base),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateStr,
                  style: const TextStyle(color: Colors.white60, fontSize: 12)),
              const Text('manahpro.id',
                  style: TextStyle(color: Colors.white60, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.entry});

  final GroupLeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final p = entry.participant;
    final name = p.labelOr('Saya');

    // DNF-friendly score column (task 7.4): never a shaming 0.
    final String scoreLabel;
    final String? subLabel;
    if (!entry.hasStarted) {
      scoreLabel = '—';
      subLabel = 'belum mulai';
    } else if (!entry.isComplete) {
      scoreLabel = '${p.totalScore}';
      subLabel = 'belum selesai';
    } else {
      scoreLabel = '${p.totalScore}';
      subLabel = null;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: ManahSpacing.sm, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: entry.rank <= 3 ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(ManahRadius.md),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              _rankBadge(entry.rank),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: ManahSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if (subLabel != null)
                  Text(
                    subLabel,
                    style: const TextStyle(color: Colors.white60, fontSize: 11),
                  ),
              ],
            ),
          ),
          const SizedBox(width: ManahSpacing.sm),
          Text(
            scoreLabel,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  /// Medals for the podium, plain number otherwise.
  String _rankBadge(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '$rank';
    }
  }
}
