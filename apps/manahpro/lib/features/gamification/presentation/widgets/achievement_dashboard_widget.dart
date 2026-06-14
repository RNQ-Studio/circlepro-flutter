import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../gamification_providers.dart';

class AchievementDashboardWidget extends ConsumerWidget {
  const AchievementDashboardWidget({super.key});

  IconData _getIconData(String code) {
    switch (code) {
      case 'grade':
        return Icons.grade;
      case 'play_arrow':
        return Icons.play_arrow;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'military_tech':
        return Icons.military_tech;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'stars':
        return Icons.stars;
      default:
        return Icons.emoji_events_outlined;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(gamificationStatsProvider);
    final theme = Theme.of(context);

    return statsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: ManahSpacing.base),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, _) => Container(
        padding: const EdgeInsets.all(ManahSpacing.base),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(ManahRadius.md),
        ),
        child: Text('Gagal memuat prestasi: $err', style: const TextStyle(fontSize: 12)),
      ),
      data: (stats) {
        final currentXpInLevel = stats.xp % 500;
        final xpProgress = currentXpInLevel / 500.0;
        final nextLevelXp = (stats.level) * 500;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: ManahSpacing.lg),
            Text('Prestasi & Level', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: ManahSpacing.xs),

            // Level and XP Card
            Container(
              padding: const EdgeInsets.all(ManahSpacing.base),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: ManahColors.brandSurface,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'Lvl ${stats.level}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ManahColors.brand,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: ManahSpacing.base),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Kemajuan Level', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Text(
                                  '${stats.xp} / $nextLevelXp XP',
                                  style: const TextStyle(fontSize: 12, color: ManahColors.mediumGrey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: xpProgress,
                                minHeight: 8,
                                backgroundColor: theme.dividerColor.withValues(alpha: 0.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(ManahColors.brand),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: ManahSpacing.lg),
                  // Streak info
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${stats.currentStreak} Hari',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const Text('Streak Latihan', style: TextStyle(fontSize: 11, color: ManahColors.mediumGrey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 32, color: theme.dividerColor),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.emoji_events_outlined, color: Colors.amber, size: 28),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${stats.longestStreak} Hari',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const Text('Streak Terbaik', style: TextStyle(fontSize: 11, color: ManahColors.mediumGrey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: ManahSpacing.base),

            // Badges Grid
            Text('Lencana Anda', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: ManahSpacing.xs),
            if (stats.badges.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(ManahSpacing.base),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                ),
                child: const Center(
                  child: Text(
                    'Belum ada lencana yang terdaftar di sistem.',
                    style: TextStyle(color: ManahColors.mediumGrey, fontSize: 13),
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: ManahSpacing.sm,
                  mainAxisSpacing: ManahSpacing.sm,
                  childAspectRatio: 0.85,
                ),
                itemCount: stats.badges.length,
                itemBuilder: (context, index) {
                  final badge = stats.badges[index];
                  final unlocked = badge.unlocked;

                  return Opacity(
                    opacity: unlocked ? 1.0 : 0.45,
                    child: Container(
                      padding: const EdgeInsets.all(ManahSpacing.xs),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                        border: Border.all(
                          color: unlocked ? ManahColors.brand.withValues(alpha: 0.3) : theme.dividerColor.withValues(alpha: 0.1),
                          width: unlocked ? 1.5 : 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: unlocked ? ManahColors.brandSurface : theme.dividerColor.withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getIconData(badge.iconCode),
                              color: unlocked ? ManahColors.brand : ManahColors.mediumGrey,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            badge.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                          const SizedBox(height: 2),
                          Expanded(
                            child: Text(
                              badge.description,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 9, color: ManahColors.mediumGrey, height: 1.2),
                            ),
                          ),
                          if (unlocked && badge.unlockedAt != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              DateFormat('dd/MM/yy').format(badge.unlockedAt!),
                              style: const TextStyle(fontSize: 8, color: ManahColors.brand, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
