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
    required this.onSettingsTap,
    required this.onLogoutTap,
  });

  final UserProfile profile;
  final UserStatsEntity? stats;
  final VoidCallback onProfileTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final currentLevelXp = stats != null ? (stats!.xp % 500) : 0;
    final progress = stats != null ? (currentLevelXp / 500.0) : 0.0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.08 : 0.05),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Greeting & Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selamat datang,',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              // Action Buttons (Settings & Logout)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.settings_outlined, 
                      color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8), 
                      size: 20,
                    ),
                    onPressed: onSettingsTap,
                    tooltip: 'Pengaturan',
                    style: IconButton.styleFrom(
                      backgroundColor: theme.dividerColor.withValues(alpha: isDark ? 0.12 : 0.06),
                      padding: const EdgeInsets.all(6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.logout_rounded, 
                      color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8), 
                      size: 20,
                    ),
                    onPressed: onLogoutTap,
                    tooltip: 'Keluar',
                    style: IconButton.styleFrom(
                      backgroundColor: theme.dividerColor.withValues(alpha: isDark ? 0.12 : 0.06),
                      padding: const EdgeInsets.all(6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Middle Section: Avatar & Name + Email + Role/Streak
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: isDark ? 0.25 : 0.15),
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.dividerColor.withValues(alpha: 0.1),
                    backgroundImage: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                        ? NetworkImage(profile.avatarUrl!)
                        : null,
                    child: profile.avatarUrl == null || profile.avatarUrl!.isEmpty
                        ? Icon(
                            Icons.person_rounded,
                            size: 24,
                            color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // User Info (Takes all remaining width so name can display fully!)
              Expanded(
                child: GestureDetector(
                  onTap: onProfileTap,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        profile.name,
                        style: TextStyle(
                          color: theme.textTheme.titleMedium?.color ?? (isDark ? Colors.white : ManahColors.nearBlack),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.email,
                        style: TextStyle(
                          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.dividerColor.withValues(alpha: isDark ? 0.18 : 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              profile.role.toUpperCase(),
                              style: TextStyle(
                                color: theme.textTheme.bodySmall?.color,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          if (stats != null && stats!.currentStreak > 0) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.local_fire_department_rounded,
                              color: ManahColors.error,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${stats!.currentStreak} Hari Streak',
                              style: const TextStyle(
                                color: ManahColors.error,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (stats != null) ...[
            const SizedBox(height: 16),
            // Divider
            Container(
              height: 1,
              color: theme.dividerColor.withValues(alpha: 0.08),
            ),
            const SizedBox(height: 12),
            // Level & XP bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level ${stats!.level}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$currentLevelXp / 500 XP',
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.dividerColor.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(ManahColors.brand),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
