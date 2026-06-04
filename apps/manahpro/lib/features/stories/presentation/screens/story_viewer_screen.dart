import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../../../../shared/models/user_simple_entity.dart';
import '../../domain/story_entities.dart';
import '../stories_provider.dart';
import 'package:features_shared/features_shared.dart';

class StoryViewerScreen extends StatefulWidget {
  const StoryViewerScreen({
    super.key,
    required this.groups,
    required this.initialIndex,
  });

  final List<StoryGroupEntity> groups;
  final int initialIndex;

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  late PageController _groupPageController;
  late int _currentGroupIndex;

  @override
  void initState() {
    super.initState();
    _currentGroupIndex = widget.initialIndex;
    _groupPageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _groupPageController.dispose();
    super.dispose();
  }

  void _onGroupFinished(bool next) {
    if (next) {
      if (_currentGroupIndex < widget.groups.length - 1) {
        setState(() {
          _currentGroupIndex++;
        });
        _groupPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // Last user finished, close viewer
        Navigator.pop(context);
      }
    } else {
      if (_currentGroupIndex > 0) {
        setState(() {
          _currentGroupIndex--;
        });
        _groupPageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        // Swipe down to dismiss
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
            Navigator.pop(context);
          }
        },
        child: PageView.builder(
          controller: _groupPageController,
          physics: const NeverScrollableScrollPhysics(), // handle programmatically or swipe down
          itemCount: widget.groups.length,
          itemBuilder: (context, index) {
            final group = widget.groups[index];
            return StoryUserViewer(
              key: ValueKey(group.userId),
              group: group,
              isActive: index == _currentGroupIndex,
              onFinished: _onGroupFinished,
              onClose: () => Navigator.pop(context),
            );
          },
        ),
      ),
    );
  }
}

class StoryUserViewer extends ConsumerStatefulWidget {
  const StoryUserViewer({
    super.key,
    required this.group,
    required this.isActive,
    required this.onFinished,
    required this.onClose,
  });

  final StoryGroupEntity group;
  final bool isActive;
  final Function(bool next) onFinished;
  final VoidCallback onClose;

  @override
  ConsumerState<StoryUserViewer> createState() => _StoryUserViewerState();
}

class _StoryUserViewerState extends ConsumerState<StoryUserViewer> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  VideoPlayerController? _videoController;
  int _currentStoryIndex = 0;
  bool _isVideoInitialized = false;
  final Set<String> _viewedStories = {};

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });

    if (widget.isActive) {
      _loadStory();
    }
  }

  @override
  void didUpdateWidget(covariant StoryUserViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _loadStory();
    } else if (!widget.isActive && oldWidget.isActive) {
      _pauseStory();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _loadStory() {
    _animController.stop();
    _animController.reset();
    _videoController?.dispose();
    _videoController = null;
    _isVideoInitialized = false;

    if (_currentStoryIndex >= widget.group.stories.length) {
      widget.onFinished(true);
      return;
    }

    final story = widget.group.stories[_currentStoryIndex];

    // Trigger story view tracking when watching other users' stories
    final authState = ref.read(authProvider);
    final currentUserId = authState is AuthAuthenticated ? authState.user.id : null;
    final isMyStory = widget.group.userId.toString() == currentUserId;

    if (!isMyStory && !_viewedStories.contains(story.id)) {
      _viewedStories.add(story.id);
      ref.read(storyRepositoryProvider).markStoryAsViewed(story.id).catchError((e) {
        debugPrint('Failed to mark story as viewed: $e');
      });
    }

    if (story.mediaType == 'video') {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(story.mediaUrl))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isVideoInitialized = true;
            });
            _videoController!.play();
            _animController.duration = _videoController!.value.duration;
            _animController.forward();
          }
        });
    } else {
      // Image story: fixed duration (5 seconds)
      _animController.duration = const Duration(seconds: 5);
      _animController.forward();
    }
  }

  void _pauseStory() {
    _animController.stop();
    _videoController?.pause();
  }

  void _resumeStory() {
    if (_videoController != null && _isVideoInitialized) {
      _videoController!.play();
    }
    _animController.forward();
  }

  void _nextStory() {
    if (_currentStoryIndex < widget.group.stories.length - 1) {
      setState(() {
        _currentStoryIndex++;
      });
      _loadStory();
    } else {
      widget.onFinished(true);
    }
  }

  void _prevStory() {
    if (_currentStoryIndex > 0) {
      setState(() {
        _currentStoryIndex--;
      });
      _loadStory();
    } else {
      widget.onFinished(false);
    }
  }

  Future<void> _deleteStory(String storyId) async {
    _pauseStory();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Cerita'),
        content: const Text('Apakah Anda yakin ingin menghapus cerita ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(storiesProvider.notifier).removeStory(storyId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cerita berhasil dihapus')),
          );
          if (widget.group.stories.length <= 1) {
            widget.onClose();
          } else {
            widget.onFinished(true);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus: $e')),
          );
          _resumeStory();
        }
      }
    } else {
      _resumeStory();
    }
  }

  void _showViewerList(String storyId) {
    _pauseStory();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StoryViewerListSheet(storyId: storyId);
      },
    ).then((_) {
      _resumeStory();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentStoryIndex >= widget.group.stories.length) {
      return const SizedBox.shrink();
    }

    final story = widget.group.stories[_currentStoryIndex];
    final authState = ref.watch(authProvider);
    final currentUserId = authState is AuthAuthenticated ? authState.user.id : null;
    final isMyStory = widget.group.userId.toString() == currentUserId;

    return SafeArea(
      child: Stack(
        children: [
          // Media Player / Previewer
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (details) {
                _pauseStory();
              },
              onTapUp: (details) {
                _resumeStory();
                final width = MediaQuery.of(context).size.width;
                if (details.globalPosition.dx < width / 3) {
                  _prevStory();
                } else {
                  _nextStory();
                }
              },
              onLongPressEnd: (details) {
                _resumeStory();
              },
              child: Center(
                child: story.mediaType == 'video'
                    ? (_isVideoInitialized && _videoController != null
                        ? AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          )
                        : const CircularProgressIndicator(color: Colors.white))
                    : Image.network(
                        story.mediaUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator(color: Colors.white));
                        },
                      ),
              ),
            ),
          ),

          // Top Bars: Segments of stories
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Row(
              children: List.generate(
                widget.group.stories.length,
                (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _buildProgressBar(index),
                  ),
                ),
              ),
            ),
          ),

          // User Info & Close
          Positioned(
            top: 24,
            left: 16,
            right: 16,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: widget.group.avatarUrl != null && widget.group.avatarUrl!.isNotEmpty
                      ? NetworkImage(widget.group.avatarUrl!)
                      : null,
                  child: widget.group.avatarUrl == null || widget.group.avatarUrl!.isEmpty
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.group.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (story.createdAt != null)
                        Text(
                          _timeAgo(story.createdAt!),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),
                if (isMyStory)
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                    onPressed: () => _deleteStory(story.id),
                  ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),

          // Caption & Views Count overlay (Bottom Actions)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (story.caption != null && story.caption!.isNotEmpty) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      story.caption!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (isMyStory)
                  GestureDetector(
                    onTap: () => _showViewerList(story.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.remove_red_eye_outlined, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Dilihat oleh ${story.viewsCount} orang',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int index) {
    if (index < _currentStoryIndex) {
      return Container(
        height: 3,
        color: Colors.white,
      );
    } else if (index > _currentStoryIndex) {
      return Container(
        height: 3,
        color: Colors.white.withOpacity(0.4),
      );
    } else {
      return AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                height: 3,
                color: Colors.white.withOpacity(0.4),
              ),
              FractionallySizedBox(
                widthFactor: _animController.value,
                child: Container(
                  height: 3,
                  color: Colors.white,
                ),
              ),
            ],
          );
        },
      );
    }
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m yang lalu';
    if (diff.inHours < 24) return '${diff.inHours}j yang lalu';
    return '${diff.inDays}d yang lalu';
  }
}

class StoryViewerListSheet extends ConsumerWidget {
  const StoryViewerListSheet({super.key, required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<UserSimpleEntity>>(
      future: ref.read(storyRepositoryProvider).getStoryViewers(storyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 300,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Gagal memuat penonton: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          );
        }

        final viewers = snapshot.data ?? [];
        if (viewers.isEmpty) {
          return const SizedBox(
            height: 250,
            child: Center(
              child: Text(
                'Belum ada penonton',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  'Penonton (${viewers.length})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Divider(color: Colors.white10, height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewers.length,
                  itemBuilder: (context, index) {
                    final viewer = viewers[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: viewer.avatarUrl != null && viewer.avatarUrl!.isNotEmpty
                            ? NetworkImage(viewer.avatarUrl!)
                            : null,
                        child: viewer.avatarUrl == null || viewer.avatarUrl!.isEmpty
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      title: Text(
                        viewer.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        '@${viewer.username ?? ""}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
