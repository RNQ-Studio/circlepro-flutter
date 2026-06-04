import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../shared/routes/social_routes.dart';
import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../monetization/domain/monetization_entities.dart';
import '../../../monetization/presentation/monetization_providers.dart';
import '../../../monetization/presentation/widgets/ad_card_widget.dart';
import '../../domain/post_entity.dart';
import '../feed_providers.dart';
import '../widgets/comments_sheet.dart';

/// Community feed (task 2.12, 4.1): posts with like + comment, and shared scorecards.
class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(feedFilterProvider);
    final activeSort = ref.watch(feedSortProvider);
    final async = ref.watch(feedProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Komunitas', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(
              activeSort == 'engagement' ? Icons.trending_up : Icons.sort,
              color: activeSort == 'engagement' ? ManahColors.brand : null,
            ),
            tooltip: activeSort == 'engagement' ? 'Urutan: Populer' : 'Urutan: Terbaru',
            onPressed: () {
              ref.read(feedSortProvider.notifier).setSort(
                activeSort == 'engagement' ? null : 'engagement',
              );
            },
          ),
        ],
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
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text('Posting', style: TextStyle(color: Colors.white)),
        backgroundColor: ManahColors.brand,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: ManahColors.brand)),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(ManahSpacing.xl),
            child: Text('Gagal memuat feed (butuh login & koneksi).\n$e', textAlign: TextAlign.center),
          ),
        ),
        data: (posts) {
          final subStatus = ref.watch(userSubscriptionProvider).value;
          final isPremium = subStatus?.isPremium ?? false;
          final ads = !isPremium ? (ref.watch(adsListProvider(placement: 'feed')).value ?? []) : <AdEntity>[];

          final List<dynamic> items = [];
          int adIndex = 0;
          for (int i = 0; i < posts.length; i++) {
            items.add(posts[i]);
            if (!isPremium && ads.isNotEmpty && (i + 1) % 5 == 0) {
              items.add(ads[adIndex % ads.length]);
              adIndex++;
            }
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(feedProvider.notifier).refreshFeed(),
            child: items.isEmpty
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
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.sm),
                    itemBuilder: (context, i) {
                      final item = items[i];
                      if (item is PostEntity) {
                        return _PostCard(post: item);
                      } else if (item is AdEntity) {
                        return AdCardWidget(ad: item);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
          );
        },
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
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManahRadius.md),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
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
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                        if (post.createdAt != null)
                          Text(_relative(post.createdAt!), style: theme.textTheme.bodySmall?.copyWith(color: ManahColors.mediumGrey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (post.body != null && post.body!.isNotEmpty) ...[
              const SizedBox(height: ManahSpacing.sm),
              Text(post.body!, style: const TextStyle(fontSize: 14, height: 1.4)),
            ],

            // Display Media Attachments
            if (post.media.isNotEmpty) ...[
              const SizedBox(height: ManahSpacing.sm),
              _PostMediaGallery(media: post.media),
            ],

            // Display Poll Card
            if (post.poll != null) ...[
              const SizedBox(height: ManahSpacing.sm),
              _PostPollCard(postId: post.id, poll: post.poll!),
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
                  color: post.isLiked ? ManahColors.error : ManahColors.mediumGrey,
                  label: '${post.likeCount}',
                  onTap: () => ref.read(feedProvider.notifier).toggleLike(post),
                ),
                const SizedBox(width: ManahSpacing.base),
                _ActionButton(
                  icon: Icons.mode_comment_outlined,
                  color: ManahColors.mediumGrey,
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

class _PostMediaGallery extends StatefulWidget {
  const _PostMediaGallery({required this.media});
  final List<FeedMedia> media;

  @override
  State<_PostMediaGallery> createState() => _PostMediaGalleryState();
}

class _PostMediaGalleryState extends State<_PostMediaGallery> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.media.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ManahRadius.md),
            child: PageView.builder(
              itemCount: widget.media.length,
              onPageChanged: (idx) => setState(() => _currentIndex = idx),
              itemBuilder: (context, i) {
                final m = widget.media[i];
                final isVideo = m.type == 'video';

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    if (!isVideo)
                      Image.network(
                        m.url,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      )
                    else
                      Container(
                        color: Colors.black87,
                        child: const Center(
                          child: Icon(Icons.video_library, size: 48, color: Colors.white70),
                        ),
                      ),
                    if (isVideo)
                      Center(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                builder: (context) => _VideoPlayerDialog(videoUrl: m.url),
                              );
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow_rounded, size: 36, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
        if (widget.media.length > 1) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.media.length,
              (idx) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == idx ? ManahColors.brand : Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _VideoPlayerDialog extends StatefulWidget {
  const _VideoPlayerDialog({required this.videoUrl});
  final String videoUrl;

  @override
  State<_VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<_VideoPlayerDialog> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ManahRadius.md)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_initialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          else
            const CircularProgressIndicator(color: Colors.white),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 24),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          if (_initialized)
            Positioned(
              bottom: 10,
              child: IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: Colors.white,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying ? _controller.pause() : _controller.play();
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _PostPollCard extends ConsumerWidget {
  const _PostPollCard({required this.postId, required this.poll});
  final String postId;
  final PollEntity poll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final hasVoted = poll.userVotedOptionId != null;
    final showResults = hasVoted || poll.isExpired;

    return Container(
      padding: const EdgeInsets.all(ManahSpacing.base),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(ManahRadius.md),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.poll_outlined, size: 18, color: ManahColors.brand),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  poll.question,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: ManahSpacing.base),
          ...poll.options.map((opt) {
            final isUserChoice = opt.id == poll.userVotedOptionId;
            final percent = poll.totalVotes > 0 ? (opt.votesCount / poll.totalVotes * 100).round() : 0;

            if (showResults) {
              return Container(
                margin: const EdgeInsets.only(bottom: ManahSpacing.xs),
                height: 40,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Progress Bar background
                    ClipRRect(
                      borderRadius: BorderRadius.circular(ManahRadius.sm),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: percent / 100,
                        child: Container(
                          color: isUserChoice
                              ? ManahColors.brandSurface
                              : theme.dividerColor.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    // Option Text and percentage
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isUserChoice ? ManahColors.brand : theme.dividerColor.withValues(alpha: 0.1),
                        ),
                        borderRadius: BorderRadius.circular(ManahRadius.sm),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            opt.optionText,
                            style: TextStyle(
                              fontWeight: isUserChoice ? FontWeight.bold : FontWeight.normal,
                              color: isUserChoice ? ManahColors.brand : null,
                            ),
                          ),
                          Text(
                            '$percent%',
                            style: TextStyle(
                              fontWeight: isUserChoice ? FontWeight.bold : FontWeight.normal,
                              color: isUserChoice ? ManahColors.brand : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Interactive button to vote
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: ManahSpacing.xs),
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(feedProvider.notifier).vote(postId, poll.id, opt.id);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ManahRadius.sm)),
                    side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.sm),
                    child: Text(
                      opt.optionText,
                      style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                    ),
                  ),
                ),
              );
            }
          }),
          const SizedBox(height: 6),
          Text(
            '${poll.totalVotes} suara · ${poll.isExpired ? "Selesai" : "Berlangsung"}',
            style: const TextStyle(fontSize: 10, color: ManahColors.mediumGrey),
          ),
        ],
      ),
    );
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
            Text(label, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}
