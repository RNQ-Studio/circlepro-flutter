import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:features_shared/features_shared.dart';
import '../stories_provider.dart';
import '../../../home/presentation/home_provider.dart';

class StoryHeaderListWidget extends ConsumerWidget {
  const StoryHeaderListWidget({super.key});

  Future<void> _pickMedia(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    // Allow either image or video
    final XFile? file = await showModalBottomSheet<XFile?>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tambah Ke Story',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(
                  context,
                  icon: Icons.image_rounded,
                  label: 'Pilih Gambar',
                  onTap: () async {
                    final img = await picker.pickImage(source: source);
                    if (context.mounted) Navigator.pop(context, img);
                  },
                ),
                _buildPickerOption(
                  context,
                  icon: Icons.videocam_rounded,
                  label: 'Pilih Video',
                  onTap: () async {
                    final vid = await picker.pickVideo(
                      source: source,
                      maxDuration: const Duration(seconds: 30),
                    );
                    if (context.mounted) Navigator.pop(context, vid);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );

    if (file != null && context.mounted) {
      context.push('/stories/preview', extra: file.path);
    }
  }

  Widget _buildPickerOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storiesProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Container(
      height: 104,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: storiesAsync.when(
        data: (storyGroups) {
          final profile = profileAsync.asData?.value;
          final authState = ref.watch(authProvider);
          final currentUserId = authState is AuthAuthenticated ? authState.user.id : null;
          if (profile == null || currentUserId == null) return const SizedBox.shrink();

          // Cek apakah user saat ini punya story aktif
          final myStoryGroupIndex = storyGroups.indexWhere((g) => g.userId.toString() == currentUserId);
          final hasMyStory = myStoryGroupIndex != -1;

          // Buat list tanpa myStoryGroup di posisi tengah, kita akan render myStory di posisi pertama
          final otherGroups = storyGroups.where((g) => g.userId.toString() != currentUserId).toList();


          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: otherGroups.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // RENDER LINGKARAN STORY SAYA
                return GestureDetector(
                  onTap: () {
                    if (hasMyStory) {
                      context.push('/stories/view', extra: {
                        'groups': storyGroups,
                        'initialIndex': myStoryGroupIndex,
                      });
                    } else {
                      _pickMedia(context, ImageSource.gallery);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2.5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: hasMyStory
                                    ? Border.all(color: Colors.blueAccent, width: 2)
                                    : null,
                              ),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage: profile.avatarUrl != null &&
                                        profile.avatarUrl!.isNotEmpty
                                    ? NetworkImage(profile.avatarUrl!)
                                    : null,
                                child: profile.avatarUrl == null || profile.avatarUrl!.isEmpty
                                    ? const Icon(Icons.person_rounded, size: 28, color: Colors.white)
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Colors.blueAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Cerita Anda',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final group = otherGroups[index - 1];
              // Cari index asli di dalam list storyGroups
              final originalIndex = storyGroups.indexOf(group);

              return GestureDetector(
                onTap: () {
                  context.push('/stories/view', extra: {
                    'groups': storyGroups,
                    'initialIndex': originalIndex,
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFF12711), // Instagram-like orange
                              Color(0xFFF5AF19), // Instagram-like yellow
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: group.avatarUrl != null && group.avatarUrl!.isNotEmpty
                                ? NetworkImage(group.avatarUrl!)
                                : null,
                            child: group.avatarUrl == null || group.avatarUrl!.isEmpty
                                ? const Icon(Icons.person_rounded, size: 26, color: Colors.grey)
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 68,
                        child: Text(
                          group.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _ShimmerCircle(),
              SizedBox(width: 14),
              _ShimmerCircle(),
              SizedBox(width: 14),
              _ShimmerCircle(),
            ],
          ),
        ),
        error: (e, _) => const SizedBox.shrink(),
      ),
    );
  }
}

class _ShimmerCircle extends StatelessWidget {
  const _ShimmerCircle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 48,
          height: 8,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}
