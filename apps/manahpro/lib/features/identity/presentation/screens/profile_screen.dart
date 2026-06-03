import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/routes/social_routes.dart';
import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../events/presentation/events_providers.dart';
import '../../domain/profile_entity.dart';
import '../profile_providers.dart';
import '../../../gamification/presentation/widgets/achievement_dashboard_widget.dart';
import '../../../gamification/presentation/gamification_providers.dart';

/// ManahPro athlete profile (task 2.3): avatar, identity, stats and bow setup.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(SocialRoutes.editProfile),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(ManahSpacing.xl),
            child: Text('Gagal memuat profil (butuh login & koneksi).\n$e', textAlign: TextAlign.center),
          ),
        ),
        data: (p) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(myProfileProvider);
            ref.invalidate(myRatingsProvider);
            ref.invalidate(gamificationStatsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(ManahSpacing.base),
            children: [
              _Header(profile: p),
              const SizedBox(height: ManahSpacing.lg),
              _StatsRow(stats: p.stats),
              const AchievementDashboardWidget(),
              _RatingsSection(userId: p.id.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.profile});
  final ProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = [profile.city, profile.province].whereType<String>().where((s) => s.isNotEmpty).join(', ');

    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: ManahColors.brandSurface,
          backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
          child: profile.avatarUrl == null
              ? const Icon(Icons.person, size: 44, color: ManahColors.brand)
              : null,
        ),
        const SizedBox(height: ManahSpacing.md),
        Text(profile.displayName, style: theme.textTheme.headlineSmall),
        if (profile.username != null)
          Text('@${profile.username}', style: theme.textTheme.bodyMedium?.copyWith(color: ManahColors.mediumGrey)),
        if (profile.bio != null && profile.bio!.isNotEmpty) ...[
          const SizedBox(height: ManahSpacing.sm),
          Text(profile.bio!, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: ManahSpacing.sm),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: ManahSpacing.sm,
          children: [
            if (profile.primaryBowClass != null)
              Chip(
                avatar: const Icon(Icons.sports, size: 16, color: ManahColors.brand),
                label: Text(profile.primaryBowClass!.label),
              ),
            if (location.isNotEmpty)
              Chip(avatar: const Icon(Icons.place_outlined, size: 16), label: Text(location)),
          ],
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});
  final ProfileStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(label: 'Sesi', value: '${stats.totalSessions}'),
        _Stat(label: 'Panah', value: '${stats.totalArrows}'),
        _Stat(label: 'PB', value: '${stats.personalBests}'),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: ManahSpacing.xs),
        padding: const EdgeInsets.symmetric(vertical: ManahSpacing.base),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(ManahRadius.md),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.titleLarge),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _RatingsSection extends ConsumerWidget {
  const _RatingsSection({required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingsAsync = ref.watch(myRatingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: ManahSpacing.lg),
        Text('Rating & Gelar', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: ManahSpacing.xs),
        ratingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Text('Gagal memuat rating: $err'),
          data: (ratings) {
            if (ratings.isEmpty) {
              return Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ManahRadius.md),
                  side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(ManahSpacing.base),
                  child: Center(
                    child: Text(
                      'Belum ada rating resmi. Silakan ikuti event resmi untuk mendapatkan kalkulasi rating.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: ManahColors.mediumGrey),
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ratings.length,
              separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.xs),
              itemBuilder: (context, index) {
                final r = ratings[index];
                Color bandColor = ManahColors.rankIron;
                if (r.color == 'gold') {
                  bandColor = ManahColors.rankGold;
                } else if (r.color == 'diamond' || r.color == 'blue') {
                  bandColor = ManahColors.rankDiamond;
                } else if (r.color == 'silver') {
                  bandColor = ManahColors.rankSilver;
                } else if (r.color == 'bronze') {
                  bandColor = ManahColors.rankBronze;
                }

                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ManahRadius.md),
                    side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Text(
                      '${r.bowClass.toUpperCase()} - ${r.distanceCategory}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: bandColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: bandColor.withValues(alpha: 0.3), width: 0.5),
                          ),
                          child: Text(
                            r.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${r.eventsCount} Event',
                          style: const TextStyle(fontSize: 11, color: ManahColors.mediumGrey),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          r.displayRating.round().toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: ManahColors.brand,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: ManahColors.mediumGrey),
                      ],
                    ),
                    onTap: () {
                      context.push('/profiles/$userId/ratings/${r.id}');
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
