import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../profile_providers.dart';

/// FollowListScreen displays followers/following directories (Phase 4).
class FollowListScreen extends ConsumerWidget {
  const FollowListScreen({
    super.key,
    required this.userId,
    required this.isFollowersMode,
  });

  final int userId;
  final bool isFollowersMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = isFollowersMode
        ? ref.watch(followersListProvider(userId))
        : ref.watch(followingListProvider(userId));

    final theme = Theme.of(context);
    final title = isFollowersMode ? 'Pengikut' : 'Mengikuti';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: listAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(ManahSpacing.xl),
            child: Text('Gagal memuat daftar.\n$e', textAlign: TextAlign.center),
          ),
        ),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(ManahSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isFollowersMode ? Icons.people_outline : Icons.person_add_alt_1_outlined,
                      size: 64,
                      color: ManahColors.mediumGrey.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: ManahSpacing.md),
                    Text(
                      isFollowersMode
                          ? 'Belum memiliki pengikut.'
                          : 'Belum mengikuti siapa pun.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: ManahColors.mediumGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(ManahSpacing.base),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.xs),
            itemBuilder: (context, index) {
              final p = list[index];
              final location = [p.city, p.province].whereType<String>().where((s) => s.isNotEmpty).join(', ');

              return Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ManahRadius.md),
                  side: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.15),
                    width: 0.5,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: ManahColors.brandSurface,
                    backgroundImage: p.avatarUrl != null ? NetworkImage(p.avatarUrl!) : null,
                    child: p.avatarUrl == null
                        ? const Icon(Icons.person, size: 24, color: ManahColors.brand)
                        : null,
                  ),
                  title: Text(
                    p.displayName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (p.username != null)
                        Text(
                          '@${p.username}',
                          style: const TextStyle(fontSize: 12, color: ManahColors.mediumGrey),
                        ),
                      if (location.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.place_outlined, size: 12, color: ManahColors.mediumGrey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location,
                                style: const TextStyle(fontSize: 11, color: ManahColors.mediumGrey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right, color: ManahColors.mediumGrey),
                  onTap: () {
                    // Navigate to target user profile
                    context.push('/profiles/${p.id}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
