import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/routes/social_routes.dart';
import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/post_entity.dart';
import '../feed_providers.dart';
import '../widgets/comments_sheet.dart';

/// Community feed (task 2.12): posts with like + comment, and shared scorecards.
class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(feedFilterProvider);
    final async = ref.watch(feedProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Komunitas'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.only(left: ManahSpacing.base, right: ManahSpacing.base, bottom: ManahSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(ManahRadius.md),
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _FeedTabButton(
                    label: 'Semua',
                    isActive: activeFilter == null,
                    onTap: () => ref.read(feedFilterProvider.notifier).setFilter(null),
                  ),
                ),
                Expanded(
                  child: _FeedTabButton(
                    label: 'Diikuti',
                    isActive: activeFilter == 'following',
                    onTap: () => ref.read(feedFilterProvider.notifier).setFilter('following'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(SocialRoutes.createPost),
        icon: const Icon(Icons.edit),
        label: const Text('Posting'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(ManahSpacing.xl),
            child: Text('Gagal memuat feed (butuh login & koneksi).\n$e', textAlign: TextAlign.center),
          ),
        ),
        data: (posts) => RefreshIndicator(
          onRefresh: () => ref.read(feedProvider.notifier).refreshFeed(),
          child: posts.isEmpty
              ? ListView(children: [
                  const SizedBox(height: 120),
                  Center(
                    child: Text(
                      activeFilter == 'following'
                          ? 'Belum ada postingan dari pemanah yang Anda ikuti.'
                          : 'Belum ada postingan. Jadilah yang pertama!',
                      style: const TextStyle(color: ManahColors.mediumGrey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ])
              : ListView.separated(
                  padding: const EdgeInsets.all(ManahSpacing.base),
                  itemCount: posts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.sm),
                  itemBuilder: (context, i) => _PostCard(post: posts[i]),
                ),
        ),
      ),
    );
  }
}

class _FeedTabButton extends StatelessWidget {
  const _FeedTabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? ManahColors.brandSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(ManahRadius.sm),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? ManahColors.brand : theme.textTheme.bodyMedium?.color,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _PostCard extends ConsumerWidget {
  const _PostCard({required this.post});
  final PostEntity post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (post.authorId != null) {
                  context.push('/profiles/${post.authorId}');
                }
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: ManahColors.brandSurface,
                    backgroundImage: post.authorAvatar != null ? NetworkImage(post.authorAvatar!) : null,
                    child: post.authorAvatar == null ? const Icon(Icons.person, size: 18, color: ManahColors.brand) : null,
                  ),
                  const SizedBox(width: ManahSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.authorName ?? post.authorUsername ?? 'Pemanah',
                            style: theme.textTheme.titleSmall),
                        if (post.createdAt != null)
                          Text(_relative(post.createdAt!), style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (post.body != null && post.body!.isNotEmpty) ...[
              const SizedBox(height: ManahSpacing.sm),
              Text(post.body!),
            ],
            if (post.shared != null) ...[
              const SizedBox(height: ManahSpacing.sm),
              _SharedCard(shared: post.shared!),
            ],
            const SizedBox(height: ManahSpacing.sm),
            Row(
              children: [
                _ActionButton(
                  icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: post.isLiked ? ManahColors.error : null,
                  label: '${post.likeCount}',
                  onTap: () => ref.read(feedProvider.notifier).toggleLike(post),
                ),
                const SizedBox(width: ManahSpacing.base),
                _ActionButton(
                  icon: Icons.mode_comment_outlined,
                  label: '${post.commentCount}',
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => CommentsSheet(postId: post.id),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _relative(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}j';
    return '${diff.inDays}h';
  }
}

class _SharedCard extends StatelessWidget {
  const _SharedCard({required this.shared});
  final SharedSnapshot shared;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ManahSpacing.md),
      decoration: BoxDecoration(
        color: ManahColors.brandSurface,
        borderRadius: BorderRadius.circular(ManahRadius.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.track_changes, color: ManahColors.brand),
          const SizedBox(width: ManahSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${shared.totalScore ?? '-'} / ${shared.maxPossibleScore ?? '-'}',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: ManahColors.brand, fontSize: 18),
                ),
                Text(
                  [shared.bowClass, shared.distanceCategory].whereType<String>().join(' · '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (shared.isPersonalBest) const Text('PB 🎯', style: TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.onTap, this.color});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ManahRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}
