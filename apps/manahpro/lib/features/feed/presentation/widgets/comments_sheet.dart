import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../feed_providers.dart';

/// Bottom-sheet comment thread for a post (task 2.12).
class CommentsSheet extends ConsumerStatefulWidget {
  const CommentsSheet({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final body = _controller.text.trim();
    if (body.isEmpty) return;
    setState(() => _sending = true);
    try {
      await ref.read(feedRepositoryProvider).addComment(widget.postId, body);
      _controller.clear();
      ref.invalidate(postCommentsProvider(widget.postId));
      ref.invalidate(feedProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(postCommentsProvider(widget.postId));

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (context, controller) => Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(ManahSpacing.base),
              child: Text('Komentar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            const Divider(height: 1),
            Expanded(
              child: async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Gagal memuat: $e')),
                data: (comments) => comments.isEmpty
                    ? const Center(child: Text('Belum ada komentar.'))
                    : ListView.builder(
                        controller: controller,
                        itemCount: comments.length,
                        itemBuilder: (context, i) {
                          final c = comments[i];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: ManahColors.brandSurface,
                              backgroundImage: c.authorAvatar != null ? NetworkImage(c.authorAvatar!) : null,
                              child: c.authorAvatar == null
                                  ? const Icon(Icons.person, size: 18, color: ManahColors.brand)
                                  : null,
                            ),
                            title: Text(c.authorName ?? 'Pemanah', style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(c.body),
                          );
                        },
                      ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(ManahSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: 'Tulis komentar...'),
                    ),
                  ),
                  IconButton(
                    onPressed: _sending ? null : _send,
                    icon: const Icon(Icons.send, color: ManahColors.brand),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
