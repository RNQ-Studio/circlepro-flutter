import 'package:flutter/material.dart';

import '../../../../theme/manah_colors.dart';
import '../../domain/entities/user_profile.dart';
import '../../../gamification/domain/gamification_entities.dart';

class HomeUserHeader extends StatelessWidget {
  const HomeUserHeader({
    super.key,
    required this.profile,
    this.stats,
    required this.onProfileTap,
  });

  final UserProfile profile;
  final UserStatsEntity? stats;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final currentLevelXp = stats != null ? (stats!.xp % 500) : 0;
    final progress = stats != null ? (currentLevelXp / 500.0) : 0.0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.08 : 0.05),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Avatar
                  GestureDetector(
                    onTap: onProfileTap,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: theme.dividerColor.withValues(alpha: 0.1),
                      backgroundImage: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                          ? NetworkImage(profile.avatarUrl!)
                          : null,
                      child: profile.avatarUrl == null || profile.avatarUrl!.isEmpty
                          ? Icon(
                              Icons.person_rounded,
                              size: 20,
                              color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                profile.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: theme.textTheme.titleMedium?.color ?? (isDark ? Colors.white : ManahColors.nearBlack),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (stats != null) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: theme.dividerColor.withValues(alpha: isDark ? 0.15 : 0.06),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'LVL ${stats!.level}',
                                  style: TextStyle(
                                    color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                profile.email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.55),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            if (stats != null && stats!.currentStreak > 0) ...[
                              const SizedBox(width: 6),
                              Text(
                                '•',
                                style: TextStyle(
                                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.local_fire_department_rounded,
                                color: ManahColors.error,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${stats!.currentStreak} Hari',
                                style: const TextStyle(
                                  color: ManahColors.error,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (stats != null)
              LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.dividerColor.withValues(alpha: 0.05),
                valueColor: const AlwaysStoppedAnimation<Color>(ManahColors.brand),
                minHeight: 2.5,
              ),
          ],
        ),
      ),
    );
  }
}
