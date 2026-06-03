import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/routes/social_routes.dart';
import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../events/presentation/events_providers.dart';
import '../../domain/profile_entity.dart';
import '../profile_providers.dart';

/// UserProfileScreen shows another archer's public profile (Phase 4).
class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(publicProfileProvider(userId));
    final myProfileAsync = ref.watch(myProfileProvider);
    final theme = Theme.of(context);

    final isMe = myProfileAsync.asData?.value.id == userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pemanah'),
        actions: [
          if (isMe)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push(SocialRoutes.editProfile),
            ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(ManahSpacing.xl),
            child: Text('Gagal memuat profil.\n$e', textAlign: TextAlign.center),
          ),
        ),
        data: (p) {
          final location = [p.city, p.province].whereType<String>().where((s) => s.isNotEmpty).join(', ');

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(publicProfileProvider(userId));
              ref.invalidate(userRatingsProvider(userId.toString()));
            },
            child: ListView(
              padding: const EdgeInsets.all(ManahSpacing.base),
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: ManahColors.brandSurface,
                      backgroundImage: p.avatarUrl != null ? NetworkImage(p.avatarUrl!) : null,
                      child: p.avatarUrl == null
                          ? const Icon(Icons.person, size: 44, color: ManahColors.brand)
                          : null,
                    ),
                    const SizedBox(height: ManahSpacing.md),
                    Text(p.displayName, style: theme.textTheme.headlineSmall),
                    if (p.username != null)
                      Text('@${p.username}', style: theme.textTheme.bodyMedium?.copyWith(color: ManahColors.mediumGrey)),
                    
                    // Social stats (Followers / Following)
                    const SizedBox(height: ManahSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => context.push('/profiles/$userId/followers'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.md, vertical: ManahSpacing.xs),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(ManahRadius.sm),
                              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${p.followersCount}',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Pengikut',
                                  style: theme.textTheme.bodySmall?.copyWith(color: ManahColors.mediumGrey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: ManahSpacing.md),
                        GestureDetector(
                          onTap: () => context.push('/profiles/$userId/following'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.md, vertical: ManahSpacing.xs),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(ManahRadius.sm),
                              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${p.followingCount}',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Mengikuti',
                                  style: theme.textTheme.bodySmall?.copyWith(color: ManahColors.mediumGrey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: ManahSpacing.md),
                    if (!isMe) ...[
                      // Follow/Unfollow button with loading state
                      _FollowButton(userId: userId, isFollowing: p.isFollowing),
                      const SizedBox(height: ManahSpacing.md),
                    ],

                    if (p.bio != null && p.bio!.isNotEmpty) ...[
                      const SizedBox(height: ManahSpacing.sm),
                      Text(p.bio!, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                    ],
                    const SizedBox(height: ManahSpacing.sm),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: ManahSpacing.sm,
                      children: [
                        if (p.primaryBowClass != null)
                          Chip(
                            avatar: const Icon(Icons.sports, size: 16, color: ManahColors.brand),
                            label: Text(p.primaryBowClass!.label),
                          ),
                        if (location.isNotEmpty)
                          Chip(avatar: const Icon(Icons.place_outlined, size: 16), label: Text(location)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: ManahSpacing.lg),
                _StatsRow(stats: p.stats),
                _RatingsSection(userId: p.id.toString()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FollowButton extends ConsumerStatefulWidget {
  const _FollowButton({required this.userId, required this.isFollowing});

  final int userId;
  final bool isFollowing;

  @override
  ConsumerState<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<_FollowButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: _isLoading
          ? const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : widget.isFollowing
              ? OutlinedButton.icon(
                  onPressed: _toggleFollow,
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Batal Mengikuti'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: ManahColors.brand),
                    foregroundColor: ManahColors.brand,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ManahBorderRadius.button),
                    ),
                  ),
                )
              : FilledButton.icon(
                  onPressed: _toggleFollow,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Ikuti'),
                  style: FilledButton.styleFrom(
                    backgroundColor: ManahColors.brand,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ManahBorderRadius.button),
                    ),
                  ),
                ),
    );
  }

  Future<void> _toggleFollow() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(publicProfileProvider(widget.userId).notifier).toggleFollow();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengubah status ikuti: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
    final ratingsAsync = ref.watch(userRatingsProvider(userId));

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
                      'Belum ada rating resmi.',
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
